{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/pingfinder"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/borgmatic"
    "${self}/profiles/k3s/agent.nix"
    "${self}/profiles/etcd"
    "${self}/profiles/komari-agent"
    # Container
    "${self}/containers/act-runner.nix"
    "${self}/containers/cloudflared.nix"
    "${self}/containers/patroni.nix"
  ];

  # Config
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "127.0.0.1"
      "8.8.8.8"
    ];
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
        ipv4.addresses = [
          {
            address = "10.0.0.97";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2603:c020:8012:a322::cd17";
            prefixLength = 64;
          }
        ];
      };
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.4";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:4::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/var/lib"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [
    deploy-rs
    git
  ];

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${pkgs.iptables}/bin/iptables -t nat -C PREROUTING -p tcp --dport 30465 -j DNAT --to-destination 148.251.67.66:465 || ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 30465 -j DNAT --to-destination 148.251.67.66:465"
      "* * * * * root ${pkgs.iptables}/bin/iptables -t nat -C POSTROUTING ! -s 10.0.0.97 -p tcp --dport 465 -j SNAT --to-source 10.0.0.97 || ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING ! -s 10.0.0.97 -p tcp --dport 465 -j SNAT --to-source 10.0.0.97"
      "0 0,4,8,12,16,20 * * * root ${pkgs.iproute2}/bin/ip a a fd21:5c0c:9b7e:bc04::/64 dev lo"
      "0 2,6,10,14,18,22 * * * root ${pkgs.iproute2}/bin/ip a d fd21:5c0c:9b7e:bc04::/64 dev lo"
      "* * * * * root /persist/zombies/run.sh"
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

  # borgmatic
  services.borgmatic.settings = {
    remote_path = "borg14";
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
    source_directories = [
      "/persist/docker"
      "/persist/heatmap"
    ];
  };

  # Wrap
  sops.secrets.wrap.sopsFile = ./secrets.yml;
  networking.wireguard.interfaces.wrap = {
    table = "913335";
    privateKeyFile = config.sops.secrets.wrap.path;
    ips = [
      "172.16.0.2/32"
      "2606:4700:110:8a58:691f:bae7:cc3e:5ebc/128"
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

  # ranet
  services.ranet = {
    enable = true;
    interface = "enp0s3";
    id = 19;
  };

  # Act Runner
  virtualisation.oci-containers.containers = {
    act-runner = {
      environment = {
        GITEA_RUNNER_LABELS = "dn42-arm:docker://ghcr.io/catthehacker/ubuntu:act-latest";
      };
    };
  };

  # komari-agent
  services.komari-agent = {
    month-rotate = 21;
    include-nics = [ "enp0s3" ];
  };

  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig = {
    ExecStartPost = [
      "${pkgs.iptables}/bin/iptables -t mangle -A PREROUTING -i tailscale0 -d 172.20.0.0/14 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source 172.22.68.4"
      "${pkgs.iptables}/bin/ip6tables -t mangle -A PREROUTING -i tailscale0 -d fd00::/8 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source fd21:5c0c:9b7e:4::1"
    ];
    ExecStopPost = [
      "${pkgs.iptables}/bin/iptables -t mangle -D PREROUTING -i tailscale0 -d 172.20.0.0/14 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source 172.22.68.4"
      "${pkgs.iptables}/bin/ip6tables -t mangle -D PREROUTING -i tailscale0 -d fd00::/8 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source fd21:5c0c:9b7e:4::1"
    ];
  };

}
