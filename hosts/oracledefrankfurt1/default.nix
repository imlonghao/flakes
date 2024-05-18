{ config, modulesPath, pkgs, profiles, self, ... }:
let
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # GoEdge
    /persist/edge-node/bin/edge-node start
  '';
in
{
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
        ipv4.addresses = [
          { address = "10.0.0.97"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2603:c020:8012:a322::cd17"; prefixLength = 64; }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address = "172.22.68.4"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "fd21:5c0c:9b7e:4::"; prefixLength = 64; }
        ];
      };
    };
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist" = {
    directories = [
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
    docker-compose
    git
  ];

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

  # Docker
  virtualisation.docker.enable = true;

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
      "0 * * * * root ${pkgs.fping}/bin/fping -i 1 -r 1 -a -q -g 172.20.0.0/14 > /persist/heatmap/`date +\\%Y\\%m\\%d\\%H`.log"
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
    location = {
      repositories = [
        "ssh://wx86wp48@wx86wp48.repo.borgbase.com/./repo"
        "ssh://zh2646@zh2646.rsync.net/./oracledefrankfurt1"
      ];
      source_directories = [
        "/persist/docker"
        "/persist/heatmap"
      ];
    };
  };

}
