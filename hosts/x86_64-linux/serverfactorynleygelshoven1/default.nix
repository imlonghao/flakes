{ self, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/qemuGuest"
    "${self}/profiles/docker"
    "${self}/profiles/k3s/server.nix"
  ];

  networking = {
    nameservers = [
      "2a09::"
      "2a11::"
      "8.8.8.8"
      "1.1.1.1"
    ];
    dhcpcd.enable = false;
    defaultGateway = "31.41.249.1";
    defaultGateway6 = "2a07:e042::1";
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "23.146.88.0";
            prefixLength = 32;
          }
          {
            address = "23.146.88.7";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:30::";
            prefixLength = 128;
          }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          {
            address = "31.41.249.39";
            prefixLength = 24;
          }
          {
            address = "192.168.112.3";
            prefixLength = 31;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a07:e042:1:47::1";
            prefixLength = 32;
          }
          {
            address = "fd74:e849:e9bc:ee83::15";
            prefixLength = 127;
          }
        ];
      };
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 20;
  };

}
