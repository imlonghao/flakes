{ pkgs, profiles, ... }: {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
    profiles.sing-box
    profiles.mtrsb
    profiles.docker
  ];

  networking = {
    nameservers = [ "104.234.20.6" "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "157.254.178.1";
    defaultGateway6 = "2400:8a20:190::1";
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "157.254.178.55";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2400:8a20:190::69";
          prefixLength = 48;
        }];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.42/24";
    ipv6 = "2602:feda:1bf:deaf::42/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull" ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
  };

}
