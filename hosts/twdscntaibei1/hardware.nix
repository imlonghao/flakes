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

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2ed6d6e9-9d9d-4f8c-b35d-f2b0d61d8330";
    fsType = "btrfs";
    options = [ "subvol=@root" ] ++ mountOptions;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2ed6d6e9-9d9d-4f8c-b35d-f2b0d61d8330";
    fsType = "btrfs";
    options = [ "subvol=@boot" ] ++ mountOptions;
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2ed6d6e9-9d9d-4f8c-b35d-f2b0d61d8330";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/2ed6d6e9-9d9d-4f8c-b35d-f2b0d61d8330";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ mountOptions;
    neededForBoot = true;
  };

}
