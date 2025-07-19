{ self, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
  ];

  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    defaultGateway.address = "185.154.155.254";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "23.146.88.0";
            prefixLength = 32;
          }
          {
            address = "23.146.88.5";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:27::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:27::123";
            prefixLength = 128;
          }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          {
            address = "185.154.155.64";
            prefixLength = 23;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a07:8dc1:20:149::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  # chrony
  services.chrony = {
    servers = [
      "ntp.kuro-home.net"
      "time.spdwpl.net"
      "chronos.asda.gr"
      "time.niewels.de"
      "clock.fmt.he.net"
    ];
    extraConfig = ''
      bindaddress 2602:fab0:27::123
      allow ::/0
    '';
  };
  services.chrony_exporter = {
    enable = true;
    listen = "[2602:fab0:27::123]:9000";
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens18";
    id = 21;
  };

}
