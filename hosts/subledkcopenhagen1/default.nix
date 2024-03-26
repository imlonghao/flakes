{ config, pkgs, profiles, self, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.netdata
    profiles.rsshc
  ];

  networking = {
    nameservers = [ "1.1.1.1" "2a09::" "2a11::" ];
    dhcpcd.enable = false;
    defaultGateway = "192.121.118.1";
    defaultGateway6 = "2001:67c:bec:a::1";
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:32::"; prefixLength = 128; }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          { address = "192.121.118.39"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2001:67c:bec:a:a04c:ffff:fe90:8b81"; prefixLength = 64; }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          { address = "10.200.10.2"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "fd00:19:96:32::1"; prefixLength = 64; }
        ];
      };
      eth2 = {
        ipv6.addresses = [
          { address = "2001:67c:bec:c7:0:19:9632:1"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.38/24";
    ipv6 = "2602:feda:1bf:deaf::38/64";
  };

}
