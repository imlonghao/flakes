{ pkgs, profiles, ... }:
let
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # GoEdge
    /persist/edge-admin/bin/edge-admin start
  '';
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.rsshc
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
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
          { address = "45.142.247.152"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a12:8d02:2100:2f3:5054:ff:fe34:d487"; prefixLength = 64; }
        ];
      };
      lo = {
        ipv6.addresses = [
          { address = "2602:feda:1bf::"; prefixLength = 128; }
          { address = "2a09:b280:ff84::"; prefixLength = 128; }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/root/.ssh"
      "/root/.edge-admin"
      "/root/.edge-api"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

  # Mariadb
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.23/24";
    ipv6 = "2602:feda:1bf:deaf::23/64";
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
}
