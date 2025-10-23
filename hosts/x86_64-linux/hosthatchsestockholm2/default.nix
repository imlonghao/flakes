{ self, pkgs, ... }:
{
  imports = [
    ./borg.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/k3s/agent.nix"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    defaultGateway = {
      interface = "eth0";
      address = "185.213.24.1";
    };
    defaultGateway6 = {
      interface = "eth0";
      address = "fe80::1";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "185.213.24.33";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a0e:dc0:2:baf5::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 33;
  };

}
