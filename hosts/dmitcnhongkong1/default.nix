{ profiles, ... }:
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.docker
    profiles.rsshc
  ];

  boot.loader.grub.device = "/dev/vda";

  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [ "154.3.37.101/32" ];
      matchConfig.Name = "eth0";
      routes = [
        {
          Gateway = "193.41.250.250";
          GatewayOnLink = true;
        }
      ];
    };
  };
  networking = {
    useDHCP = false;
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
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
