{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    # ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    # profiles.pingfinder
    profiles.exporter.node
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    defaultGateway6 = "2605:6400:40::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "172.22.68.6";
          prefixLength = 32;
        }
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:6::";
          prefixLength = 64;
        }
      ];
      ens3.ipv6.addresses = [
        {
          address = "2605:6400:40:fdeb::";
          prefixLength = 48;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # rait
  services.gravity = {
    enable = true;
    address = "100.64.88.69/30";
    addressV6 = "2602:feda:1bf:a:12::1/80";
    hostAddress = "100.64.88.70/30";
    hostAddressV6 = "2602:feda:1bf:a:12::2/80";
  };

}
