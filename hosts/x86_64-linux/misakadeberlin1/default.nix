{ self, pkgs, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/sing-box"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/blackbox.nix"
    "${self}/profiles/k3s/server.nix"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = {
      interface = "eth0";
      address = "100.100.0.0";
    };
    defaultGateway6 = {
      interface = "eth0";
      address = "fe80::1";
    };
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "45.142.247.152";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a12:8d02:2100:2f3:5054:ff:fe34:d487";
            prefixLength = 64;
          }
        ];
      };
      lo = {
        ipv6.addresses = [
          {
            address = "2602:feda:1bf::";
            prefixLength = 128;
          }
          {
            address = "2a09:b280:ff84::";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/root/.ssh"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [ docker-compose ];

  # Mariadb
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      default-address-pools = [
        {
          "base" = "100.65.0.0/16";
          "size" = 24;
        }
      ];
      #      userland-proxy = false;
      experimental = true;
      ip6tables = true;
    };
  };

  # Postgresql
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = ''
      host kong kong 0.0.0.0/0 scram-sha-256
      host blackbgp blackbgp 0.0.0.0/0 scram-sha-256
    '';
    ensureDatabases = [ "kong" ];
    ensureUsers = [
      {
        name = "kong";
        ensureDBOwnership = true;
      }
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 15;
  };

}
