{ modulesPath, ... }:
let
  mountOptions = [
    "relatime"
    "compress-force=zstd"
    "space_cache=v2"
  ];
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "defaults"
      "mode=755"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/vda2";
    fsType = "btrfs";
    options = [ "subvol=@boot" ] ++ mountOptions;
  };
  fileSystems."/nix" = {
    device = "/dev/vda2";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/persist" = {
    device = "/dev/vda2";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ mountOptions;
    neededForBoot = true;
  };

}
