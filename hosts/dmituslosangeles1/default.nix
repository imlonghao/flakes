{ config, pkgs, profiles, ... }: {
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.tuic
    profiles.rsshc
    profiles.exporter.node
    profiles.docker
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    dhcpcd.enable = false;
    defaultGateway = "154.17.16.1";
    defaultGateway6 = {
      address = "fe80::5c3c:9dff:feca:8922";
      interface = "eth0";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "154.17.16.135";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2605:52c0:2:4ad::1";
          prefixLength = 64;
        }];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.36/24";
    ipv6 = "2602:feda:1bf:deaf::36/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull" ];
  };

  sops.secrets.juicity.sopsFile = ./secrets.yml;
  services.juicity.enable = true;

  services.qemuGuest.enable = true;

}
