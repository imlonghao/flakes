{ self, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/etcd"
    "${self}/profiles/komari-agent"
  ];

  networking = {
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    dhcpcd.enable = false;
    defaultGateway = "23.150.40.65";
    defaultGateway6 = "2602:02b7:40:64::1";
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "23.146.88.0";
            prefixLength = 32;
          }
          {
            address = "23.146.88.4";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:28::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:28::123";
            prefixLength = 128;
          }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          {
            address = "23.150.40.72";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:02b7:40:64::72";
            prefixLength = 64;
          }
        ];
      };
      ens19 = {
        ipv4.addresses = [
          {
            address = "149.112.75.29";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fa3d:f4:1::29";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  # chrony
  services.chrony = {
    servers = [
      "ntp.netviscom.com"
      "time-clock.borgnet.us"
      "time-b.intt.org"
      "clock.sjc.he.net"
      "clock.fmt.he.net"
    ];
    extraConfig = ''
      bindaddress 2602:fab0:28::123
      allow ::/0
    '';
  };
  services.chrony_exporter = {
    enable = true;
    listen = "[2602:fab0:28::123]:9000";
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens18";
    id = 3;
  };

  # komari-agent
  services.komari-agent = {
    include-nics = [
      "ens18"
      "ens19"
    ];
  };

}
