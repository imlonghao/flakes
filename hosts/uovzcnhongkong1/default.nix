{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    profiles.nomad
    profiles.pingfinder
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    defaultGateway = "103.200.114.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      ens3.ipv4.addresses = [
        {
          address = "103.200.114.26";
          prefixLength = 25;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "172.22.68.3";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:3::";
          prefixLength = 64;
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
    ];
  };

  # Nomad
  environment.etc."nomad-mutable.hcl".text = ''
    bind_addr = "103.200.114.26"
    client {
      meta = {
        iinomiko = "103.200.114.26"
      }
    }
  '';
  services.nomad.extraSettingsPaths = [ "/etc/nomad-mutable.hcl" ];

  # rait
  services.gravity = {
    enable = true;
    address = "100.64.88.9/30";
    addressV6 = "2602:feda:1bf:a:3::1/80";
    hostAddress = "100.64.88.10/30";
    hostAddressV6 = "2602:feda:1bf:a:3::2/80";
  };

}
