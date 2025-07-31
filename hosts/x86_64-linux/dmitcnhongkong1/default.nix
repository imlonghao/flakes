{ self, ... }:
{
  imports = [
    ./dn42.nix
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/docker"
    "${self}/profiles/rsshc"
    "${self}/profiles/pingfinder"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/komari-agent"
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
    networks.lo = {
      address = [
        "172.22.68.0/32"
        "172.22.68.3/32"
        "fd21:5c0c:9b7e:3::1/64"
      ];
      matchConfig.Name = "lo";
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

  services.komari-agent = {
    month-rotate = 26;
    include-mountpoint = "/boot;/persist";
  };

}
