{ modulesPath, ... }:
let
  mountOptions = [
    "relatime"
    "compress-force=zstd"
    "space_cache=v2"
  ];
in
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@root" ] ++ mountOptions;
  };
  fileSystems."/nix" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/boot" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@boot" ] ++ mountOptions;
  };

}
