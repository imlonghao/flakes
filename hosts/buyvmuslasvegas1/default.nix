{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    profiles.pingfinder
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    defaultGateway6 = "2605:6400:20::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "172.22.68.5";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:5::";
          prefixLength = 64;
        }
      ];
      ens3.ipv6.address = [
        {
          address = "2605:6400:20:803::";
          prefixLength = 48;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/run/secrets"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # rait
  services.gravity = {
    enable = true;
    address = "100.64.88.65/30";
    addressV6 = "2602:feda:1bf:a:11::1/80";
    hostAddress = "100.64.88.66/30";
    hostAddressV6 = "2602:feda:1bf:a:11::2/80";
  };

}
