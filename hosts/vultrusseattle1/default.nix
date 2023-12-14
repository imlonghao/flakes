{ config, pkgs, profiles, sops, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.rsshc
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway = {
      address = "137.220.42.1";
      interface = "enp1s0";
    };
    defaultGateway6 = {
      address = "fe80::fc00:4ff:fe57:26c3";
      interface = "enp1s0";
    };
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:25::"; prefixLength = 128; }
        ];
      };
      enp1s0 = {
        ipv4.addresses = [
          { address = "137.220.42.181"; prefixLength = 23; }
        ];
        ipv6.addresses = [
          { address = "2001:19f0:8001:1eb:5400:4ff:fe57:26c3"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.32/24";
    ipv6 = "2602:feda:1bf:deaf::32/64";
  };

}
