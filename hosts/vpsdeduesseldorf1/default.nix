{ pkgs, profiles, ... }: {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.rsshc
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "45.131.153.1";
    defaultGateway6 = "2a03:d9c0:2000::1";
    dhcpcd.enable = false;
    interfaces = {
      enp6s18 = {
        ipv4.addresses = [{
          address = "45.131.153.201";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2a03:d9c0:2000::c2";
          prefixLength = 48;
        }];
      };
      enp6s19 = {
        ipv4.addresses = [{
          address = "185.1.155.119";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2a0c:b641:701::13:3846:1";
          prefixLength = 64;
        }];
      };
      lo = {
        ipv4.addresses = [{
          address = "44.31.42.0";
          prefixLength = 32;
        }];
        ipv6.addresses = [
          {
            address = "2a09:b280:ff80::";
            prefixLength = 48;
          }
          {
            address = "2602:feda:1bf::";
            prefixLength = 48;
          }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.21/24";
    ipv6 = "2602:feda:1bf:deaf::21/64";
  };

}
