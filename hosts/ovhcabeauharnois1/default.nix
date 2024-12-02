{ pkgs, profiles, ... }: {
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
  ];

  boot.loader.grub.device = "/dev/sda";

  networking = {
    dhcpcd.allowInterfaces = [ "eno1" ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.44/24";
    ipv6 = "2602:feda:1bf:deaf::44/64";
  };

}
