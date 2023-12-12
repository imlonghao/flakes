{ config, modulesPath, pkgs, profiles, self, ... }:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    (modulesPath + "/profiles/qemu-guest.nix")
    profiles.bird-lg-go
    profiles.mtrsb
    profiles.rsshc
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.1";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:1::";
      prefixLength = 64;
    }
  ];

  # hardware-configuration.nix
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/vda2"; }];

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.26/24";
    ipv6 = "2602:feda:1bf:deaf::10/64";
  };

}
