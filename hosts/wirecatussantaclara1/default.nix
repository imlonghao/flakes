{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIBP3czRr6GPW1XajqjzX6hBpezWdIY+pLSntfMUMnKdBAAAAIP0Nrr+lXzoZjpvo8zaBKJBPCVIaHw10eJ9YTnFjRR7fAAAAAAAAAAAAAAACAAAAFHdpcmVjYXR1c3NhbnRhY2xhcmExAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABjAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABIAAAAIA34DA/4zX6ZVXf6iCd5+oCYKQMN/59r0+9grWo0uZEHAAAAIFqgRO+Uv/aZl6Qjb3o54Mz22ct4RwZrVYfjKLUxnQXl";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd = {
      allowInterfaces = [ "ens3" ];
      extraConfig = "noipv4ll";
    };
    interfaces = {
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:23::"; prefixLength = 128; }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.29/24";
    ipv6 = "2602:feda:1bf:deaf::29/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
