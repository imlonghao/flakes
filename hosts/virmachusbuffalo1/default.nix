{ config, modulesPath, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIK8cGbun9zeg+kngRO6f6OBLoWM/uz6ooARoh+9IfzOQAAAAIOP8PvG1Je26mXYH8NuuDs1IDqUA08F8l6Qn8AE8gt6yAAAAAAAAAAAAAAACAAAAEXZpcm1hY2h1c2J1ZmZhbG8xAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABjAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABIAAAAIGwz3bZbvx2hPpxyQvxeZwEwR95BPgqK5CvQsIbLJiQjAAAAIFClRozD/44SLgAWOWFITL7clT5nwv4QzpFMGVh3RJAR";
in
{
  imports = [
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.1";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:1::";
      prefixLength = 64;
    }
  ];

  # hardware-configuration.nix
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/vda2"; }];

  services.myteleport.teleport.auth_token = "8658b42da9e1a5a235946ccb5a3262d0";

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.26/24";
    ipv6 = "2602:feda:1bf:deaf::10/64";
  };

}
