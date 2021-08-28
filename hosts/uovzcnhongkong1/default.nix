{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    profiles.nomad
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    defaultGateway = "14.192.50.254";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      eth0.ipv4.addresses = [
        {
          address = "14.192.50.151";
          prefixLength = 24;
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
    bind_addr = "14.192.50.151"
    client {
      meta = {
        iinomiko = "14.192.50.151"
      }
    }
  '';
  services.nomad.extraSettingsPaths = [ "/etc/nomad-mutable.hcl" ];

}
