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
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [
      "defaults"
      "mode=755"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/d2fb6f7b-3ece-4bdf-ac14-c3e124f2b8b8";
    fsType = "btrfs";
    options = [ "subvol=@boot" ] ++ mountOptions;
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d2fb6f7b-3ece-4bdf-ac14-c3e124f2b8b8";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/d2fb6f7b-3ece-4bdf-ac14-c3e124f2b8b8";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ mountOptions;
    neededForBoot = true;
  };

}
