{ profiles, ... }: {
  imports = [
    ./hardware.nix
    ./bird.nix
    ./dn42.nix
    # ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.mtrsb
    profiles.rsshc
    profiles.bird-lg-go
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "45.61.188.1";
    defaultGateway6 = "2605:6400:40::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "23.146.88.0";
          prefixLength = 32;
        }
        {
          address = "23.146.88.1";
          prefixLength = 32;
        }
        {
          address = "172.22.68.1";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "2602:fab0:20::";
          prefixLength = 128;
        }
        {
          address = "2602:fab0:2a::1";
          prefixLength = 128;
        }
        {
          address = "fd21:5c0c:9b7e:1::";
          prefixLength = 64;
        }
      ];
      ens3.ipv4.addresses = [{
        address = "45.61.188.76";
        prefixLength = 24;
      }];
      ens3.ipv6.addresses = [{
        address = "2605:6400:40:fdeb::";
        prefixLength = 48;
      }];
    };
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # NAT64
  nat64 = {
    enable = true;
    gateway = "45.61.188.1";
    interface = "ens3";
    nat_start = "23.146.88.248";
    nat_end = "23.146.88.255";
    prefix = "2602:fab0:2a:";
    address = "23.146.88.1";
    location = "mia1";
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    ipv6 = false;
    mtu = 1440;
    id = 7;
  };

}
