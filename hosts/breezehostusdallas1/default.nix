{ config, modulesPath, pkgs, profiles, self, ... }: {
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.bird-lg-go
    profiles.rsshc
  ];

  networking = {
    useDHCP = false;
    defaultGateway = "100.66.0.1";
    defaultGateway6 = "2602:fab0:41::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" "2a09::" "2a11::" ];
    interfaces = {
      lo = {
        ipv4.addresses = [{
          address = "172.22.68.10";
          prefixLength = 32;
        }];
        ipv6.addresses = [{
          address = "fd21:5c0c:9b7e:10::";
          prefixLength = 128;
        }];
      };
      ens18 = {
        mtu = 1476;
        ipv4.addresses = [{
          address = "100.66.0.4";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2602:fab0:41::42:4242:1888";
          prefixLength = 64;
        }];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.41/24";
    ipv6 = "2602:feda:1bf:deaf::41/64";
  };

}
