{ pkgs, profiles, ... }:
{
  imports = [
    ./dn42.nix
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.exporter.node
    profiles.users.root
    profiles.tuic
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.bird-lg-go
    profiles.pingfinder
    profiles.rsshc
    profiles.docker
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "178.253.52.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "172.22.68.0"; prefixLength = 32; }
          { address = "172.22.68.3"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "fd21:5c0c:9b7e:3::"; prefixLength = 64; }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          { address = "178.253.52.63"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2405:f3c0:1:8659::1"; prefixLength = 64; }
        ];
      };
    };
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.4/24";
    ipv6 = "2602:feda:1bf:deaf::4/64";
  };

}
