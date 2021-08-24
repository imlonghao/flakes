{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/44faab9b-aabd-40a2-a10d-02d7a4a90ca1";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/44faab9b-aabd-40a2-a10d-02d7a4a90ca1";
      fsType = "btrfs";
      options = [ "subvol=@boot" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/44faab9b-aabd-40a2-a10d-02d7a4a90ca1";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/44faab9b-aabd-40a2-a10d-02d7a4a90ca1";
      fsType = "btrfs";
      options = [ "subvol=@persist" ];
    };

  swapDevices = [ ];

}
