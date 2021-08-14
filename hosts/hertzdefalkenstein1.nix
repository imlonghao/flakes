{ modulesPath, profiles, ... }:
{
  imports = [
    profiles.mycore
    profiles.rait
    profiles.users.root
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "ens160" ];
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
  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };
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
  services.gravity = {
    enable = true;
    address = "100.64.88.57/30";
    addressV6 = "2602:feda:1bf:a:f::1/80";
    hostAddress = "100.64.88.58/30";
    hostAddressV6 = "2602:feda:1bf:a:f::2/80";
  };
}
