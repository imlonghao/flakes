{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    profiles.k3s
    profiles.exporter.node
    profiles.exporter.bird
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
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/run/secrets"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/rancher/node/password"
    ];
  };

  # rait
  services.gravity = {
    enable = true;
    address = "100.64.88.5/30";
    addressV6 = "2602:feda:1bf:a:2::1/80";
    hostAddress = "100.64.88.6/30";
    hostAddressV6 = "2602:feda:1bf:a:2::2/80";
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
