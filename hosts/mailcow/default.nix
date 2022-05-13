{ config, pkgs, profiles, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIGizviW/hZYYu1uiv86d+qRmHCAjONpPNNmZ8zNkG0BkAAAAIPOKFMdzyrkcCXX1PwzAQrh9Cd6DFox1ehvclBJroTOeAAAAAAAAAAAAAAACAAAAB21haWxjb3cAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGQAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEkAAAAhAMU9ZnTsMrH2EbogpD0NX1kuDb61Q7wd1Z56OeiTaqbaAAAAIC9z0A4X5OyAtz1na/QoqagdXDdO/2E163L/Ve1DhqKr";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.autorestic
  ];

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    interfaces = {
      ens3.ipv6.addresses = [
        {
          address = "2a01:4f8:1c17:ea61::";
          prefixLength = 64;
        }
      ];
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.6";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:6::";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    git
    iptables
    openssl
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/docker/daemon.json"
      "/etc/.autorestic.lock.yml"
    ];
  };

  # Docker
  virtualisation.docker.enable = true;

  # SSH Port
  services.openssh.ports = [ 2222 ];

  # Start renovate @hourly
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * root ${pkgs.docker}/bin/docker start renovate"
    ];
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.15/24";
    ipv6 = "2602:feda:1bf:deaf::15/64";
  };

  # Coredns IPv6 forwarder
  systemd.services.coredns.after = [ "etherguard-edge.service" ];
  services.coredns = {
    enable = true;
    config = ''
      .:5353 {
        bind 100.64.88.15
        forward . 172.20.0.53 172.23.0.53
        cache 30
      }
    '';
  };

  # Garage
  sops.secrets.garage = {
    sopsFile = ./secrets.yml;
    restartUnits = [ "garage.service" ];
  };
  services.garage = {
    enable = true;
    path = config.sops.secrets.garage.path;
  };

  # AutoRestic
  services.autorestic = {
    settings = {
      version = 2;
      global = {
        forget = {
          keep-hourly = 24;
          keep-daily = 7;
          keep-weekly = 4;
          keep-monthly = 6;
        };
      };
      backends = {
        garage = {
          type = "s3";
          path = "http://127.0.0.1:3900/restic";
        };
      };
      locations = {
        mailcow = {
          from = [
            "/opt/mailcow-dockerized"
          ];
          to = [
            "garage"
          ];
          cron = "0 * * * *";
          options = {
            backup = {
              exclude = [
                "querylog.json"
              ];
            };
          };
        };
        etc = {
          from = [
            "/persist/etc"
          ];
          to = [
            "garage"
          ];
          cron = "0 0 * * *";
        };
      };
    };
  };

}
