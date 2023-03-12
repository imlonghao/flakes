{ config, modulesPath, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIPxV2X/3y1IqlODxz8OMJxgv14yL/RDF/ezD4CHH4MoFAAAAIGPrYUbX2Zv3h9OfLjVu0H45ggfxX5SNLjZX+aEkUweKAAAAAAAAAAAAAAACAAAAEm9yYWNsZWRlZnJhbmtmdXJ0MQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEA4lDqutOQ4OLZYthTZmia+36Z7sfveCEmiLaQxgZyG4oAAAAhAOSrLyY0Rt/jMHJzhyGf5XMSpnuSjTZU2wXOL2WGoPue";
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # GoEdge
    /persist/edge-node/bin/edge-node start
    # Networking
    ip a s enp0s3 | grep -F "2603:c020:8012:a322::cd17" || dhcpcd -n
  '';
in
{
  imports = [
    ./dn42.nix
    ./hardware.nix
    profiles.mycore
    profiles.netdata
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.pingfinder
    profiles.bird-lg-go
  ];

  # Config
  networking = {
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
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';
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
      dn42 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 10.in-addr.arpa {
        bind 127.0.0.1
        forward . 172.20.0.53:53 172.23.0.53:53
      }
      d.f.ip6.arpa {
        bind 127.0.0.1
        forward . [fd42:d42:d42:54::1]:53 [fd42:d42:d42:53::1]:53
      }
    '';
  };

}
