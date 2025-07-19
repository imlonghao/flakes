{ self, pkgs, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/sing-box"
    "${self}/profiles/mtrsb"
    "${self}/profiles/docker"
  ];

  networking = {
    nameservers = [
      "104.234.20.6"
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = "157.254.178.1";
    defaultGateway6 = "2400:8a20:190::1";
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "157.254.178.55";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2400:8a20:190::69";
            prefixLength = 48;
          }
        ];
      };
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 13;
  };

}
