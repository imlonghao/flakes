{ profiles, ... }:

{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.rait
    profiles.exporter.node
    profiles.exporter.bird
  ];

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.allowInterfaces = [ "enp1s0" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/run/secrets"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # profiles.rait
  services.gravity = {
    enable = true;
    address = "100.64.88.49/30";
    addressV6 = "2602:feda:1bf:a:d::1/80";
    hostAddress = "100.64.88.50/30";
    hostAddressV6 = "2602:feda:1bf:a:d::2/80";
  };

}
