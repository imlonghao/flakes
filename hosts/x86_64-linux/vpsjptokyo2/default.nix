{ self, ... }:
{
  imports = [
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/hysteria2"
    "${self}/profiles/komari-agent"
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
      address = "45.66.131.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "2a12:a303:103::1";
      interface = "eth0";
    };
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "45.66.131.52";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a12:a303:103::9d";
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
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.tailscale.enable = true;

  services.komari-agent = {
    month-rotate = 18;
    include-nics = [ "eth0" ];
  };

  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 16;
  };
}
