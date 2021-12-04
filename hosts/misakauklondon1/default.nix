{ profiles, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.rait
    profiles.teleport
    profiles.exporter.node
    profiles.k3s
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "enp3s0" ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # rait
  services.gravity = {
    enable = true;
    address = "100.64.88.73/30";
    addressV6 = "2602:feda:1bf:a:13::1/80";
    hostAddress = "100.64.88.74/30";
    hostAddressV6 = "2602:feda:1bf:a:13::2/80";
  };

  # Docker
  virtualisation.docker.enable = true;
}
