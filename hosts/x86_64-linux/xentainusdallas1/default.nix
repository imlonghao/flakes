{ self, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/rsshc"
  ];

  networking = {
    nameservers = [
      "2a09::"
      "2a11::"
      "1.1.1.1"
      "8.8.8.8"
    ];
    dhcpcd.enable = false;
    defaultGateway = "5.56.24.1";
    defaultGateway6 = {
      address = "2602:f71e:41::1";
      interface = "ens3";
    };
    vlans = {
      vlan102 = {
        id = 102;
        interface = "ens3";
      };
    };
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "23.146.88.0";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:40::";
            prefixLength = 128;
          }
        ];
      };
      ens3 = {
        ipv4.addresses = [
          {
            address = "5.56.24.146";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:f71e:41:6f::a";
            prefixLength = 64;
          }
        ];
      };
      vlan102 = {
        ipv4.addresses = [
          {
            address = "172.29.47.13";
            prefixLength = 31;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:f71e::75a2:2";
            prefixLength = 126;
          }
        ];
      };
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    id = 26;
  };

}
