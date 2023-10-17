{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAII18JUsX40WMA6L7LojdirfdhMsGehHlIzfG0Hf+iZmhAAAAIFA4ysFCrVXBR/7X7u1GcNWOUkMGiyPyC/LC3/4aDXNaAAAAAAAAAAAAAAACAAAADnZpcnR1YWZybGlsbGUxAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABJAAAAIF3HViBeXDUYHCtK+ilOebHJcR1SDsm7aLTKswyVesJ2AAAAIQCNseHW07mGtMMs1NdH+v+J1IqUVlz5ww1BEQCC5fOojQ==";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.netdata
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway.address = "185.154.155.254";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
          { address = "23.146.88.5"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:27::"; prefixLength = 128; }
          { address = "2602:fab0:27::123"; prefixLength = 128; }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          { address = "185.154.155.64"; prefixLength = 23; }
        ];
        ipv6.addresses = [
          { address = "2a07:8dc1:20:149::1"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.34/24";
    ipv6 = "2602:feda:1bf:deaf::34/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # netdata
  services.netdata = {
    enable = true;
    config = {
      global = {
        "memory mode" = "none";
      };
      health = {
        "enabled " = "no";
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

}
