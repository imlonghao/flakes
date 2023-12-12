{ config, pkgs, profiles, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.netdata
    profiles.rsshc
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    dhcpcd.enable = false;
    defaultGateway = "23.150.40.65";
    defaultGateway6 = "2602:02b7:40:64::1";
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
          { address = "23.146.88.4"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:28::"; prefixLength = 128; }
          { address = "2602:fab0:28::123"; prefixLength = 128; }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          { address = "23.150.40.72"; prefixLength = 26; }
        ];
        ipv6.addresses = [
          { address = "2602:02b7:40:64::72"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.35/24";
    ipv6 = "2602:feda:1bf:deaf::35/64";
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

}
