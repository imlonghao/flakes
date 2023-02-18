{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAINlOFTukyWFrgNHPdj1QQX1BypH8xF2njCrfgnMhC8oOAAAAIL7X+FLYX1M6gfSxUlZL91SHYTbFcExJSPbREgV8ZbplAAAAAAAAAAAAAAACAAAADXZwc3Vzc2Fuam9zZTEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGQAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEkAAAAhAL0OzIbJq53sxb7w+NpbWSrnchjxLfe5+wqURHUmoJfVAAAAIAYlMT5cr7tuLxo6010pv+zdgxzPRjcbvxccnIh1Ua3Y";
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "45.139.193.1";
    defaultGateway6 = "2604:a840:2::1";
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "45.139.193.138"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2604:a840:2::157"; prefixLength = 48; }
        ];
      };
    };
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # vxwg
  services.etherguard-edge.ipv4 = "100.88.1.12/24";

}
