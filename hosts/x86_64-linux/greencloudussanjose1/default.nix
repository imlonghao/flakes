{ self, ... }:
{
  imports = [
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/docker"
  ];

  boot.kernelParams = [
    "audit=0"
    "net.ifnames=0"
  ];
  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "185.222.222.222"
      "45.11.45.11"
    ];
    defaultGateway = {
      address = "173.249.198.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "2607:9000:800:5000::1";
      interface = "eth0";
    };
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "173.249.198.10";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2607:9000:800:53f9::a";
          prefixLength = 64;
        }
      ];
      # The gateway is outside the assigned /64.
      ipv6.routes = [
        {
          address = "2607:9000:800:5000::1";
          prefixLength = 128;
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
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 14;
  };

  services.cert-syncer = {
    enable = true;
    wishlist = [ "go9mail.com" ];
  };
}
