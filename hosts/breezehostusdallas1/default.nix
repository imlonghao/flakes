{ profiles, ... }:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.bird-lg-go
    profiles.rsshc
    profiles.docker
  ];

  networking = {
    useDHCP = false;
    defaultGateway = "100.66.0.1";
    defaultGateway6 = "2602:fab0:41::1";
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
      "2a09::"
      "2a11::"
    ];
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.10";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:10::1";
            prefixLength = 128;
          }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          {
            address = "100.66.0.4";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:41::42:4242:1888";
            prefixLength = 64;
          }
          {
            address = "fe80::42:4242:1888";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  services.qemuGuest.enable = true;

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens18";
    id = 24;
    mtu = 1476;
  };

}
