{ self, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/borgmatic"
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/k3s/server.nix"
    "${self}/profiles/docker"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = {
      interface = "enp3s0";
      address = "100.100.0.0";
    };
    defaultGateway6 = {
      interface = "enp3s0";
      address = "fe80::1";
    };
    dhcpcd.enable = false;
    interfaces = {
      enp3s0 = {
        ipv4.addresses = [
          {
            address = "45.142.244.141";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0f:3b03:101:12:5054:ff:fe16:e83c";
            prefixLength = 64;
          }
        ];
      };
      lo = {
        ipv4.addresses = [
          {
            address = "44.31.42.0";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:feda:1bf::";
            prefixLength = 128;
          }
          {
            address = "2a09:b280:ff85::";
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

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        forward . 138.201.124.182
        cache 30
      }
    '';
  };

  # borgmatic
  services.borgmatic.settings = {
    configurations = {
      misaka = {
        location = {
          repositories = [
            "ssh://sxvl8201@sxvl8201.repo.borgbase.com/./repo"
            "ssh://zh2646@zh2646.rsync.net/./misakauklondon1"
          ];
          source_directories = [ "/persist/pomerium" ];
        };
      };
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "enp3s0";
    id = 4;
  };

}
