{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
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
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:5::";
          prefixLength = 64;
        }
      ];
      ens3.ipv6.addresses = [
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
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.66/24";
    ipv6 = "2602:feda:1bf:deaf::2/64";
  };

}
