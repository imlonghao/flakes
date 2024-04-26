{ config, pkgs, profiles, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.rsshc
    profiles.exporter.node
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [ "2602:fab0:29:53::" ];
    defaultGateway = {
      address = "169.254.0.1";
      interface = "ens4";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens4";
    };
    interfaces = {
      ens4 = {
        ipv4.addresses = [
          { address = "45.45.224.73"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fc52:10e:e384::2"; prefixLength = 128; }
        ];
      };
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:23::"; prefixLength = 128; }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.29/24";
    ipv6 = "2602:feda:1bf:deaf::29/64";
  };

}
