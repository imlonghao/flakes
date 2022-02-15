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

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2DE5-B1AE";
    fsType = "vfat";
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3a0d39c7-08c6-4ff7-8185-5b33ef3920f2";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/3a0d39c7-08c6-4ff7-8185-5b33ef3920f2";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ mountOptions;
    neededForBoot = true;
  };

}
