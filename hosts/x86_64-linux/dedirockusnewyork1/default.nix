{ self, ... }:
{
  imports = [
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
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "23.94.79.12";
            prefixLength = 25;
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
