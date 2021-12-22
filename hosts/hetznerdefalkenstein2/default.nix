{ pkgs, profiles, ... }:

{
  imports = [
    ./hardware.nix
    profiles.users.root
  ];

  nix.gc.dates = "monthly";

  boot.loader.grub.device = "/dev/sda";
  networking = {
    nameservers = [ "168.119.101.249" "1.1.1.1" ];
    defaultGateway = {
      interface = "enp0s31f6";
      address = "138.201.124.129";
    };
    defaultGateway6 = {
      interface = "enp0s31f6";
      address = "fe80::1";
    };
    interfaces = {
      enp0s31f6.ipv4.addresses = [
        {
          address = "138.201.124.182";
          prefixLength = 26;
        }
      ];
      enp0s31f6.ipv6.addresses = [
        {
          address = "2a01:4f8:172:27e4::";
          prefixLength = 64;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "172.22.68.6";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:6::";
          prefixLength = 64;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/var/jfsCache"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/rancher/node/password"
    ];
  };

  # Docker
  virtualisation.docker.enable = true;

}
