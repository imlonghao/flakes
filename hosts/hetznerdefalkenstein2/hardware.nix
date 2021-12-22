{ ... }:
let
  mountOptions = [
    "relatime"
    "compress-force=zstd"
    "space_cache=v2"
  ];
in
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };
  fileSystems."/boot" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@boot" ] ++ mountOptions;
  };
  fileSystems."/nix" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/pt" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@pt" "relatime" "compress=none" "compress-force=none" "space_cache=v2" ];
  };
  fileSystems."/persist" = {
    device = "/dev/sda2";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ mountOptions;
    neededForBoot = true;
  };

}
