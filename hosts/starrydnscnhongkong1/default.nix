{
  lib,
  pkgs,
  profiles,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.sing-box
    profiles.mtrsb
    profiles.rsshc
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.205.9.1";
    defaultGateway6 = {
      address = "2403:ad80:98:c00::1";
      interface = "ens3";
    };
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
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
          prefixLength = 64;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "2a09:b280:ff81::";
          prefixLength = 48;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
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

  zramSwap.enable = lib.mkForce false;

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    id = 22;
  };

}
