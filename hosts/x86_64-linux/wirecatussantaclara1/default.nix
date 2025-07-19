{ self, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/docker"
    "${self}/profiles/borgmatic"
    "${self}/profiles/k3s/agent.nix"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = {
      address = "169.254.0.1";
      interface = "ens4";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens4";
    };
    interfaces = {
      ens4 = {
        ipv4.addresses = [
          {
            address = "45.45.224.73";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fc52:10e:e384::2";
            prefixLength = 128;
          }
        ];
      };
      lo = {
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:23::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:23::25";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/var/lib"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # Borgmatic
  systemd.services.borgmatic.path = [ pkgs.mariadb ];
  services.borgmatic.settings = {
    repositories = [
      {
        path = "ssh://alb8ug6d@alb8ug6d.repo.borgbase.com/./repo";
        label = "borgbase";
      }
    ];
    source_directories = [
      "/mnt/caddy/"
      "/mnt/stalwart/"
    ];
    mariadb_databases = [
      {
        name = "stalwart";
        hostname = "127.0.0.1";
        port = 3306;
        username = "stalwart";
        password = "\${STARWART_PASSPHRASE}";
      }
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens4";
    id = 18;
  };

}
