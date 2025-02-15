{ config, modulesPath, lib, pkgs, profiles, self, ... }: {
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.pingfinder
    profiles.bird-lg-go
    profiles.mtrsb
    profiles.rsshc
    profiles.borgmatic
    profiles.docker
  ];

  # Config
  networking = {
    dhcpcd.enable = false;
    nameservers = [ "127.0.0.1" "8.8.8.8" ];
    defaultGateway = {
      interface = "enp0s3";
      address = "10.0.0.1";
    };
    defaultGateway6 = {
      interface = "enp0s3";
      address = "fe80::200:17ff:fe48:71e6";
    };
    interfaces = {
      enp0s3 = {
        ipv4.addresses = [{
          address = "10.0.0.97";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2603:c020:8012:a322::cd17";
          prefixLength = 64;
        }];
      };
      lo = {
        ipv4.addresses = [{
          address = "172.22.68.4";
          prefixLength = 32;
        }];
        ipv6.addresses = [{
          address = "fd21:5c0c:9b7e:4::";
          prefixLength = 64;
        }];
      };
    };
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist" = {
    directories = [ "/var/lib" "/root/.ssh" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [ deploy-rs git ];

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.17/24";
    ipv6 = "2602:feda:1bf:deaf::17/64";
  };

  # OpenSSH
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwH+SQ2Zn0yAjNrsXSIZL7ViulHom4LixUAZQ5e+DoW root@nixos"
    ];
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
      "* * * * * root ${pkgs.iptables}/bin/iptables -t nat -C PREROUTING -p tcp --dport 30465 -j DNAT --to-destination 148.251.67.66:465 || ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 30465 -j DNAT --to-destination 148.251.67.66:465"
      "* * * * * root ${pkgs.iptables}/bin/iptables -t nat -C POSTROUTING ! -s 10.0.0.97 -p tcp --dport 465 -j SNAT --to-source 10.0.0.97 || ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING ! -s 10.0.0.97 -p tcp --dport 465 -j SNAT --to-source 10.0.0.97"
      "0 0,4,8,12,16,20 * * * root ${pkgs.iproute2}/bin/ip a a fd21:5c0c:9b7e:bc04::/64 dev lo"
      "0 2,6,10,14,18,22 * * * root ${pkgs.iproute2}/bin/ip a d fd21:5c0c:9b7e:bc04::/64 dev lo"
    ];
  };

  # Syncthing Relay
  services.syncthing.relay = {
    enable = true;
    providedBy = "imlonghao";
  };

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 127.0.0.1
        forward . [2a09::]:53 [2a11::]:53 1.1.1.1:53 1.0.0.1:53 8.8.8.8:53 8.8.4.4:53
      }
      dn42 neo 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 10.in-addr.arpa {
        bind 127.0.0.1
        forward . 172.20.0.53:53 172.23.0.53:53
      }
      d.f.ip6.arpa {
        bind 127.0.0.1
        forward . [fd42:d42:d42:54::1]:53 [fd42:d42:d42:53::1]:53
      }
    '';
  };

  # wtt
  services.wtt = {
    enable = true;
    listen = "100.64.88.17";
  };

  # borgmatic
  services.borgmatic.settings = {
    repositories = [
      {
        label = "borgbase";
        path = "ssh://wx86wp48@wx86wp48.repo.borgbase.com/./repo";
      }
      {
        label = "rsync";
        path = "ssh://zh2646@zh2646.rsync.net/./oracledefrankfurt1";
      }
    ];
    source_directories = [ "/persist/docker" "/persist/heatmap" ];
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

  # Wrap
  sops.secrets.wrap.sopsFile = ./secrets.yml;
  networking.wireguard.interfaces.wrap = {
    table = "913335";
    privateKeyFile = config.sops.secrets.wrap.path;
    ips = [ "172.16.0.2/32" "2606:4700:110:8a58:691f:bae7:cc3e:5ebc/128" ];
    mtu = 1420;
    postSetup = [
      "${pkgs.iproute2}/bin/ip rule add from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule add from 133:35::/64 table 913335"
    ];
    postShutdown = [
      "${pkgs.iproute2}/bin/ip rule del from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule del from 133:35::/64 table 913335"
    ];
    peers = [{
      endpoint = "engage.cloudflareclient.com:2408";
      publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      persistentKeepalive = 15;
    }];
  };

}
