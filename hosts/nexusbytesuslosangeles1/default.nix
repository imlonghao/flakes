{ pkgs, profiles, ... }:

{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.k3s
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = "2602:fed2:7106::1";
    interfaces = {
      ens3.ipv6 = {
        addresses = [
          {
            address = "2602:fed2:7106:271b::1";
            prefixLength = 64;
          }
        ];
        routes = [
          {
            address = "2602:fed2:7106::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.34/24";
    ipv6 = "2602:feda:1bf:deaf::7/64";
  };

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 2602:fed2:7106:271b::1
        forward . 127.0.0.1
        cache 30
      }
    '';
  };

}
