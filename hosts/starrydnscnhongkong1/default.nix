{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.k3s
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.205.9.1";
    defaultGateway6 = "2403:ad80:98:c00::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      ens3.ipv4.addresses = [
        {
          address = "103.205.9.90";
          prefixLength = 24;
        }
      ];
      ens3.ipv6.addresses = [
        {
          address = "2403:ad80:98:c60::f6f4";
          prefixLength = 54;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/rancher/node/password"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.6/24";
    ipv6 = "2602:feda:1bf:deaf::8/64";
  };

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 2403:ad80:98:c60::f6f4
        forward . 127.0.0.1
        cache 30
      }
    '';
  };

}
