{ pkgs, profiles, ... }: {
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
  ];

  networking = {
    dhcpcd.allowInterfaces = [ "ens5" ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.43/24";
    ipv6 = "2602:feda:1bf:deaf::43/64";
  };

  # Realm
  services.realm = {
    enable = true;
    config = {
      log = {
        level = "warn";
        output = "/var/log/realm.log";
      };
      network = {
        use_udp = true;
      };
      endpoints = [
        {
          listen = "0.0.0.0:443";
          remote = "157.254.178.55:443";
        }
        {
          listen = "0.0.0.0:3389";
          remote = "157.254.178.55:9102";
        }
        {
          listen = "0.0.0.0:8443";
          remote = "103.147.22.112:443";
        }
      ];
    };
  };

}
