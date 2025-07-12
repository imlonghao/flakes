{ pkgs, profiles, ... }:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.exporter.blackbox
    profiles.rsshc
    profiles.sing-box
    profiles.mtrsb
    profiles.docker
    profiles.pingfinder
    profiles.bird-lg-go
  ];

  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = "193.32.148.1";
    defaultGateway6 = "2a12:a301:2013::1";
    dhcpcd.enable = false;
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.10";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:10::1";
            prefixLength = 64;
          }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          {
            address = "193.32.149.99";
            prefixLength = 22;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a12:a301:2013::109a";
            prefixLength = 48;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wgcf
    wireguard-tools
  ];

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 10;
  };

}
