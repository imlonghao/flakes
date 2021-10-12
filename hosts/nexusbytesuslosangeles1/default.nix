{ pkgs, profiles, ... }:

{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.rait
    profiles.k3s
    profiles.exporter.node
    profiles.exporter.bird
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
  };

  # profiles.rait
  services.gravity = {
    enable = true;
    address = "100.64.88.33/30";
    addressV6 = "2602:feda:1bf:a:9::1/80";
    hostAddress = "100.64.88.34/30";
    hostAddressV6 = "2602:feda:1bf:a:9::2/80";
  };

}
