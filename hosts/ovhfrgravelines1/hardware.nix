{ ... }:
let
  mountOptions = [
    "relatime"
    "compress-force=zstd"
    "space_cache=v2"
  ];
in
{
  boot.initrd.availableKernelModules = [ "ehci_pci" "xhci_pci" "ahci" "sd_mod" "ip6_tables" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };
  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "btrfs";
    options = [ "subvol=@boot" ] ++ mountOptions;
  };
  fileSystems."/nix" = {
    device = "/dev/sda1";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ mountOptions;
  };
  fileSystems."/persist" = {
    device = "/dev/sda1";
    fsType = "btrfs";
    options = [ "subvol=@persist" ] ++ mountOptions;
    neededForBoot = true;
  };

}
