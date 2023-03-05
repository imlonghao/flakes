{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIHXS2Ahd5+TQA7hwEgzf4g90WtOkGSsuCwm0PJ9n6XS9AAAAIHh+znKxLlCm9idznGTqBxceGOpVCDo6D+AcCJ0S1XrDAAAAAAAAAAAAAAACAAAADWJ1eXZtbHVyb29zdDEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGQAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEkAAAAgRCFpUBoYVs7DJ+GtPqrkdsifcG++i8Sso5b2EeIiFAoAAAAhAJcA9VkDTiYyoHslSf8GByDKXUfUkrrIogJV9M76nQSK";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    defaultGateway = "107.189.8.1";
    defaultGateway6 = "2605:6400:30::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "107.189.8.121"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2605:6400:30:eb56::"; prefixLength = 48; }
        ];
      };
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:21::"; prefixLength = 128; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.27/24";
    ipv6 = "2602:feda:1bf:deaf::27/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # rtorrent
  services.rtorrent = {
    enable = true;
    downloadDir = "/persist/rtorrent";
  };

}
