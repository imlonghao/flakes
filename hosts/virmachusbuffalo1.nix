{ modulesPath, profiles, ... }:
{
  imports = [
    profiles.mycore
    profiles.rait
    profiles.users.root
    profiles.teleport
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "ens3" ];

  # hardware-configuration.nix
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/vda2"; }];

  # Bird
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.26;
      protocol direct {
        ipv4;
        ipv6;
        interface "gravity";
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
      protocol babel gravity {
        ipv4 {
          import all;
          export where net ~ 100.64.88.0/24;
        };
        ipv6 {
          import all;
          export where net ~ 2602:feda:1bf::/48;
        };
        randomize router id;
        interface "gravity";
      }
    '';
  };
  services.gravity = {
    enable = true;
    address = "100.64.88.25/30";
    addressV6 = "2602:feda:1bf:a:7::1/80";
    hostAddress = "100.64.88.26/30";
    hostAddressV6 = "2602:feda:1bf:a:7::2/80";
  };
}
