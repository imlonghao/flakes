{ profiles, ... }: {
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway = {
      address = "193.41.250.250";
      interface = "eth0";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "154.3.37.101";
          prefixLength = 32;
        }];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib" ];
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
    id = 30;
  };

}
