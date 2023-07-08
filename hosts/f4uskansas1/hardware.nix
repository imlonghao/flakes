{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sym53c8xx" "ahci" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/eb2fc67c-5aed-4dcb-81d5-2c314692ce27";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/eb2fc67c-5aed-4dcb-81d5-2c314692ce27";
      fsType = "btrfs";
      options = [ "subvol=@boot" ];
    };
  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/eb2fc67c-5aed-4dcb-81d5-2c314692ce27";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

}
