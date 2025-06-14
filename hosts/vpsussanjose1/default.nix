{ pkgs, profiles, ... }:
let
  cronJob = pkgs.writeShellScript "cron.sh" ''
    # Networking
    ip -6 rule | grep -F 2602:fab0:11::/48 || ip -6 rule add from 2602:fab0:11::/48 table 2602
    ip -6 route show table 2602 | grep -F default || ip -6 route add default via 2604:a840:2::4 table 2602
  '';
in {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.mtrsb
    profiles.rsshc
    profiles.qemuGuest
    profiles.exporter.node
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "45.139.193.1";
    defaultGateway6 = "2604:a840:2::1";
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "45.139.193.138";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2604:a840:2::157";
          prefixLength = 48;
        }];
      };
      lo = {
        ipv6.addresses = [
          {
            address = "2602:feda:1bf::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:11::";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [ "* * * * * root ${cronJob} > /dev/null 2>&1" ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 11;
  };

}
