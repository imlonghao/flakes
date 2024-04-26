{ pkgs, profiles, ... }:
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
    profiles.tuic
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "193.32.148.1";
    defaultGateway6 = "2a12:a301:2::1";
    dhcpcd.enable = false;
    interfaces = {
      enp6s18 = {
        ipv4.addresses = [
          { address = "193.32.149.99"; prefixLength = 22; }
        ];
        ipv6.addresses = [
          { address = "2a12:a301:2::13be"; prefixLength = 48; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.31/24";
    ipv6 = "2602:feda:1bf:deaf::31/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

}
