{ modulesPath, pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIPxV2X/3y1IqlODxz8OMJxgv14yL/RDF/ezD4CHH4MoFAAAAIGPrYUbX2Zv3h9OfLjVu0H45ggfxX5SNLjZX+aEkUweKAAAAAAAAAAAAAAACAAAAEm9yYWNsZWRlZnJhbmtmdXJ0MQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEA4lDqutOQ4OLZYthTZmia+36Z7sfveCEmiLaQxgZyG4oAAAAhAOSrLyY0Rt/jMHJzhyGf5XMSpnuSjTZU2wXOL2WGoPue";
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
  networking.dhcpcd.allowInterfaces = [ "enp0s3" ];

  # hardware-configuration.nix
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/2DE5-B1AE"; fsType = "vfat"; };
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.17/24";
    ipv6 = "2602:feda:1bf:deaf::17/64";
  };

  services.teleport.teleport.auth_token = "81a18913b6e184a45d145f5c14446c68";

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
