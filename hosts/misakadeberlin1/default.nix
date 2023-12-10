{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIOXt5Ky4HgllBx6lN2qr+0zYXeMYt5+e8SnwUlSYUYQfAAAAIF3/kKhE8t/be9VMk7RJgd9/anolFA/bksy+Hs8Kc6/rAAAAAAAAAAAAAAACAAAAD21pc2FrYWRlYmVybGluMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAYwAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASAAAACADA7ypUvCpnibnSRdLL9H/fYcxMqQMz3alEVyoamOqbwAAACAPu2XuPY7bMhWmlr1PhQ6DgS7wF1XDxFlJRTIBE4iq8w==";
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

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * root ${cronJob} > /dev/null 2>&1"
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
