{ config, pkgs, profiles, ... }:
let
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # Networking
    ip -6 rule | grep -F 2602:fab0:26:1::/64 || ip -6 rule add from 2602:fab0:26:1::/64 table 48
    ip -6 rule | grep -F "uidrange 993-993" || ip -6 rule add uidrange 993-993 table 48
    ip -6 rule | grep -F 2a11:3:101::105b || ip -6 rule add from 2a11:3:101::105b lookup main
    ip -6 route show table 48 | grep -F default || ip -6 route add default via 2602:feda:1bf:deaf::33 src 2602:fab0:26:1:: table 48
  '';
in {
  imports = [
    ./bird.nix
    ./hardware.nix
    ./dn42.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.exporter.blackbox
    profiles.etherguard.edge
    profiles.bird-lg-go
    profiles.sing-box
    profiles.mtrsb
    profiles.rsshc
    profiles.docker
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "185.222.217.1";
    defaultGateway6 = "2a11:3:101::1";
    dhcpcd.enable = false;
    interfaces = {
      enp6s18 = {
        ipv4.addresses = [{
          address = "185.222.217.139";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2a11:3:101::105b";
          prefixLength = 48;
        }];
      };
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.9";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:9::";
            prefixLength = 64;
          }
          {
            address = "2602:fab0:26:1::";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.22/24";
    ipv6 = "2602:feda:1bf:deaf::22/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

  # Wrap
  sops.secrets.wrap.sopsFile = ./secrets.yml;
  networking.wireguard.interfaces.wrap = {
    table = "913335";
    privateKeyFile = config.sops.secrets.wrap.path;
    ips = [
      "172.16.0.2/32"
      "2606:4700:110:86e4:aa19:ba82:1aa4:9772/128"
    ];
    mtu = 1420;
    postSetup = [
      "${pkgs.iproute2}/bin/ip rule add from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule add from 133:35::/64 table 913335"
    ];
    postShutdown = [
      "${pkgs.iproute2}/bin/ip rule del from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule del from 133:35::/64 table 913335"
    ];
    peers = [
      {
        endpoint = "engage.cloudflareclient.com:2408";
        publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
        allowedIPs = [
          "0.0.0.0/0"
          "::/0"
        ];
        persistentKeepalive = 15;
      }
    ];
  };

  # Vector
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        docker = {
          type = "docker_logs";
          include_containers = [ "caddy" ];
        };
      };
      transforms = {
        parse_json = {
          type = "remap";
          inputs = [ "docker" ];
          source = ''
            . = parse_json!(.message)
            .hostname = get_hostname!()
          '';
        };
      };
      sinks = {
        caddycdn = {
          type = "http";
          inputs = [ "parse_json" ];
          uri = "https://o2.esd.cc/api/default/caddycdn/_json";
          method = "post";
          auth.strategy = "basic";
          auth.user = "\${O2_USER-default}";
          auth.password = "\${O2_PASSWORD-default}";
          compression = "gzip";
          encoding.codec = "json";
          encoding.timestamp_format = "rfc3339";
          healthcheck.enabled = false;
        };
      };
    };
  };
  sops.secrets.openobserve = { sopsFile = "${self}/secrets/openobserve.yml"; };
  systemd.services.vector.serviceConfig = {
    EnvironmentFile = config.sops.secrets.openobserve.path;
    DynamicUser = lib.mkForce false;
  };

}
