{ self, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    dhcpcd.enable = false;
    defaultGateway = "194.169.54.1";
    defaultGateway6 = "2a09:0:9::1";
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "194.169.54.18";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a09:0:9::12e";
            prefixLength = 48;
          }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          {
            address = "185.1.167.230";
            prefixLength = 23;
          }
        ];
        ipv6.addresses = [
          {
            address = "2001:7f8:f2:e1::3:0114:1";
            prefixLength = 64;
          }
        ];
      };
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
            address = "2602:fab0:22::";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 9;
  };

}
