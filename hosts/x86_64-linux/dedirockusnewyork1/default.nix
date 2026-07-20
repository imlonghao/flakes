{ self, ... }:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
  ];

  boot.kernelParams = [
    "audit=0"
    "net.ifnames=0"
  ];
  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = {
      address = "23.94.79.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "2605:6f01:2000:01bd::1";
      interface = "eth0";
    };
    interfaces = {
      dummy = {
        virtual = true;
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.13";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:13::1";
            prefixLength = 128;
          }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          {
            address = "23.94.79.12";
            prefixLength = 25;
          }
        ];
        ipv6.addresses = [
          {
            address = "2605:6f01:2000:1bd::f58b:5cbe";
            prefixLength = 64;
          }
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

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 13;
  };

}
