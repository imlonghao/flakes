{ config, pkgs, profiles, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.rsshc
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    dhcpcd.enable = false;
    defaultGateway = "194.169.54.1";
    defaultGateway6 = "2a09:0:9::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "194.169.54.18"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2a09:0:9::12e"; prefixLength = 48; }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          { address = "185.1.167.230"; prefixLength = 23; }
        ];
        ipv6.addresses = [
          { address = "2001:7f8:f2:e1::1996:32:1"; prefixLength = 64; }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:22::"; prefixLength = 128; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.28/24";
    ipv6 = "2602:feda:1bf:deaf::28/64";
  };

}
