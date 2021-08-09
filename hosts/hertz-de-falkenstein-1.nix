{ modulesPath, suites, ... }:
{
  # Config
  boot.cleanTmpDir = true;
  networking.hostName = "hertz-de-falkenstein-1";
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOg2Z8LyT58mU6l8bP+yw2d1tvLqdhfVkDIdvQrbuDVAh3+z40hFMq3RB4XLjkrQEicgRMDha0Ns4rd31i1QpyT8JXzYlLfuRhP6BAmofVTPkV46HDBzXo+ImbYKIH1fuS3tsMJjahpyfULTYAdVK+1uNjySs60gPNt1xxVWDgtOhahLu0RZnVgrXS9yC3vfZo0bWWiZuNxq92HpR9ddIJ62w47ZdtCrikX6GQW9xJOdEtNFEKz+Y9HYOL8uXOv8w1tnM3RDgc5a145ENpmcZ4/CO9TW0LKFsKTfv3C84QkbhwKd9llT/WyZ3twCLWlqCA3kgosdLWd+VDIyZ0feTr1yGCh5A7HbujYWgCft00VisKMgis9CXKR1r2q5tv32atXeWjvwcvAf7bzJkSM83LDWLUKQV6/xvOkrWMXoUSk7IQD/J/Cx+nEjLSziqulABd998s3Ie8ufARsl4uDYX1q9fjYGZyl34qtjLS8dYJtXMGcyKmYob9uStP4CXNgM80eDcMgv1Dc7n9Gs5iwPkhHuUWirEe5PTpisBSIbDBU/+mELJlNQ8Nb1XpHFpCKyNKnG4DRgZk6k1f/yetFaGIVccSqoz8yENTcMlegSuOZQEswBvWQiwMpCnwTDe9Wz3zXRbzeYyJPn/vYCIcVHbdxnJPtuVbHlnUteXuaejULw== openpgp:0x1E1A60D7"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPiPq3zWmsO7dEJS/xR8+YW2eEFpPoR7ybtXwh0kC3S imlonghao@hetzner-fi-helsinki-1"
  ];

  # hardware-configuration.nix
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
  swapDevices = [ { device = "/dev/sda5"; } ];
}
