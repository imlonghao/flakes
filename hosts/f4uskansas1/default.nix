{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIIZOj/6u0CQVBU6+HNw2RBWbb5W8HvjtR1MYZVwqteNnAAAAIIz2WhGVkd8EOU6fFSQMfoTdIn0bIDWkZVZOGvLBVdoZAAAAAAAAAAAAAAACAAAAC2Y0dXNrYW5zYXMxAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABJAAAAIQD/HlG/sQUiTI7YO6Ja+7bTDn7tl8irnTkE6wDAkv3QtwAAACBfiBBI0OB8f9XBpopvydp2iHmVRy9kBUis1E3lfre7Hg==";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.netdata
  ];

  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    dhcpcd.enable = false;
    defaultGateway = "23.150.40.65";
    defaultGateway6 = "2602:02b7:40:64::1";
    interfaces = {
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:28::"; prefixLength = 128; }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          { address = "23.150.40.72"; prefixLength = 26; }
        ];
        ipv6.addresses = [
          { address = "2602:02b7:40:64::72"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.35/24";
    ipv6 = "2602:feda:1bf:deaf::35/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
