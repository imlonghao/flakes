{ profiles, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.mtrsb
    profiles.exporter.node
    profiles.rsshc
    profiles.docker
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    dhcpcd.enable = false;
    defaultGateway = "107.189.8.1";
    defaultGateway6 = "2605:6400:30::1";
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "107.189.8.121";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2605:6400:30:eb56::";
            prefixLength = 48;
          }
        ];
      };
      lo = {
        ipv4.addresses = [
          {
            address = "23.146.88.0";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:21::";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    ipv6 = false;
    mtu = 1440;
    id = 5;
  };

}
