{ modulesPath, pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIEwMyWpuHUOOaJoDwJwWHnMRxzee2bQCXn4or4l+wIpUAAAAIGxXK+vxVnjNTxZU+MzK7jiJJJ0lcq4uOz8Oe88KBiOyAAAAAAAAAAAAAAACAAAAE2hlcnR6ZGVmYWxrZW5zdGVpbjEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGQAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEkAAAAhAOpM3M2CS8lgwIlcT/7cGk9eq/zn+wU8e76Po+EaHG82AAAAIDWgfHaNCMS8Axk8LLeZOSfc6v9QThquxU/4+5FnlI71";
in
{
  imports = [
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.exporter.node
    profiles.etherguard.edge
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
      timeformat protocol iso long;
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

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.58/24";
    ipv6 = "2602:feda:1bf:deaf::4/64";
  };

  services.myteleport.ssh_service.listen_addr = "0.0.0.0:13022";

  services.myteleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
