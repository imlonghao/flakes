{ self, ... }:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/pingfinder"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/bird.nix"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/docker"
  ];

  # Network
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    defaultGateway = {
      interface = "ens18";
      address = "185.243.216.1";
    };
    defaultGateway6 = {
      interface = "ens18";
      address = "2a03:94e0:ffff:185:243:216::1";
    };
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "185.243.216.252";
          prefixLength = 24;
        }
      ];
      ens18.ipv6.addresses = [
        {
          address = "2a03:94e0:ffff:185:243:216::252";
          prefixLength = 118;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "172.22.68.0";
          prefixLength = 32;
        }
        {
          address = "172.22.68.6";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:6::1";
          prefixLength = 64;
        }

        {
          address = "2602:feda:1bf::";
          prefixLength = 128;
        }
        {
          address = "2a09:b280:ff83::";
          prefixLength = 128;
        }
      ];
    };
  };

  # Boot
  boot.loader.grub.device = "/dev/sda";

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens18";
    id = 25;
  };

}
