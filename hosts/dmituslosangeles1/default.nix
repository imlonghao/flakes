{ pkgs, profiles, ... }:
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.sing-box
    profiles.rsshc
    profiles.exporter.node
    profiles.docker
  ];

  networking = {
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    dhcpcd.enable = false;
    defaultGateway = "154.17.16.1";
    defaultGateway6 = {
      address = "fe80::6436:5aff:fe53:bc6b";
      interface = "eth0";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "154.17.16.135";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2605:52c0:2:4ad::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  sops.secrets.juicity.sopsFile = ./secrets.yml;
  services.juicity.enable = true;

  services.qemuGuest.enable = true;

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 23;
  };

}
