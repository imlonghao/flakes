{ modulesPath, suites, ... }:
{
  # Config
  boot.cleanTmpDir = true;
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOg2Z8LyT58mU6l8bP+yw2d1tvLqdhfVkDIdvQrbuDVAh3+z40hFMq3RB4XLjkrQEicgRMDha0Ns4rd31i1QpyT8JXzYlLfuRhP6BAmofVTPkV46HDBzXo+ImbYKIH1fuS3tsMJjahpyfULTYAdVK+1uNjySs60gPNt1xxVWDgtOhahLu0RZnVgrXS9yC3vfZo0
bWWiZuNxq92HpR9ddIJ62w47ZdtCrikX6GQW9xJOdEtNFEKz+Y9HYOL8uXOv8w1tnM3RDgc5a145ENpmcZ4/CO9TW0LKFsKTfv3C84QkbhwKd9llT/WyZ3twCLWlqCA3kgosdLWd+VDIyZ0feTr1yGCh5A7HbujYWgCft00VisKMgis9CXKR1r2q5tv32atXeWjvwcvAf7bzJkSM83LDWLUKQV6/xvOkrWMXoUSk7IQD/J
/Cx+nEjLSziqulABd998s3Ie8ufARsl4uDYX1q9fjYGZyl34qtjLS8dYJtXMGcyKmYob9uStP4CXNgM80eDcMgv1Dc7n9Gs5iwPkhHuUWirEe5PTpisBSIbDBU/+mELJlNQ8Nb1XpHFpCKyNKnG4DRgZk6k1f/yetFaGIVccSqoz8yENTcMlegSuOZQEswBvWQiwMpCnwTDe9Wz3zXRbzeYyJPn/vYCIcVHbdxnJPtuVbH
lnUteXuaejULw== openpgp:0x1E1A60D7"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPiPq3zWmsO7dEJS/xR8+YW2eEFpPoR7ybtXwh0kC3S imlonghao@hetzner-fi-helsinki-1"
  ];
  networking.interfaces.ens160.ipv6.addresses = [
    {
      address = "2a0f:9400:7a00:1111:deb4::";
      prefixLength = 48;
    }
  ];
  networking.interfaces.ens192.ipv6.addresses = [
    {
      address = "2a0f:9400:7a00:3333:9e62::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway6 = {
    address = "2a0f:9400:7a00::1";
    interface = "ens160";
  };

  # hardware-configuration.nix
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/sda5"; }];

  # Bird
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.58;
      protocol direct {
        ipv4;
        ipv6;
      }
      protocol device {
        scan time 10;
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv4 {
          import none;
          export all;
        };
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv6 {
          import none;
          export where net != ::/0;
        };
      }
      protocol bgp AS135395v6 {
        neighbor 2a0f:9400:7a00::1 as 135395;
        source address 2a0f:9400:7a00:1111:deb4::;
        local as 133846;
        graceful restart on;
        ipv6 {
          import none;
          export where net = 2602:feda:1bf::/48;
        };
      }
      protocol bgp HZIXv6 {
        neighbor 2a0f:9400:7a00:3333:1111::1 as 64555;
        source address 2a0f:9400:7a00:3333:9e62::1;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48;
        };
      }
    '';
  };
}
