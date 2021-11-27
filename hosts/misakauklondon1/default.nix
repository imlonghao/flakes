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
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
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
      "/run/secrets"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

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
