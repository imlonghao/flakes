{ profiles, ... }: {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.exporter.node
    profiles.rsshc
  ];

  networking = {
    nameservers = [ "2a09::" "2a11::" "1.1.1.1" "8.8.8.8" ];
    dhcpcd.enable = false;
    defaultGateway = "5.56.24.1";
    defaultGateway6 = {
      address = "2602:f71e:41::1";
      interface = "ens3";
    };
    interfaces = {
      lo = {
        ipv4.addresses = [{
          address = "23.146.88.0";
          prefixLength = 32;
        }];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:40::";
            prefixLength = 128;
          }
        ];
      };
      ens3 = {
        ipv4.addresses = [{
          address = "5.56.24.146";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2602:f71e:41:6f::a";
          prefixLength = 64;
        }];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.40/24";
    ipv6 = "2602:feda:1bf:deaf::40/64";
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    id = 26;
  };

}
