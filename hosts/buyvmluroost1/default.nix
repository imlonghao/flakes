{ config, pkgs, profiles, self, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.netdata
    profiles.rsshc
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    dhcpcd.enable = false;
    defaultGateway = "107.189.8.1";
    defaultGateway6 = "2605:6400:30::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "107.189.8.121"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2605:6400:30:eb56::"; prefixLength = 48; }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:21::"; prefixLength = 128; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.27/24";
    ipv6 = "2602:feda:1bf:deaf::27/64";
  };

  # Docker
  virtualisation.docker.enable = true;

}
