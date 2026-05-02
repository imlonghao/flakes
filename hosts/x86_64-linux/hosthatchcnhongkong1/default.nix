{
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
  ];

  boot.kernelParams = [ "net.ifnames=0" ];
  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "185.222.222.222"
      "45.11.45.11"
    ];
    defaultGateway = {
      interface = "eth0";
      address = "194.29.187.1";
    };
    defaultGateway6 = {
      interface = "eth0";
      address = "fe80::1";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "194.29.187.71";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2406:ef80:1:9b2e::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/root/.ssh"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 34;
  };

}
