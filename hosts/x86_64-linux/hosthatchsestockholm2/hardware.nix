{
  config,
  lib,
  modulesPath,
  ...
}:
let
  mountOptions = [
    "compress-force=zstd"
    "nosuid"
    "nodev"
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
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = {
    device = "/dev/vda3";
    fsType = "btrfs";
    options = mountOptions;
  };
  fileSystems."/boot" = {
    device = "/dev/vda2";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  fileSystems."/persist" = {
    device = "/dev/vdb1";
    fsType = "btrfs";
    options = mountOptions;
    neededForBoot = true;
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
