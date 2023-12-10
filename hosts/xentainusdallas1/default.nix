{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIARixcTHznN/ZmM0VhhztMv7e6hJYAn3/wSN2p2nu/1xAAAAIMZOVGdZosYmH/UC7TLarpEi077Ij7Vac5KvOqXvhlUfAAAAAAAAAAAAAAACAAAAEHhlbnRhaW51c2RhbGxhczEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGMAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEgAAAAgD0QwnApYdl6aQGpKUrmizu3/UFwjIS1Ytj4/7QstnrUAAAAgQXfJ6sV7jeUaAh5Pf8F/U+1rD1uosGdYi/+rODXRL5Q=";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.netdata
  ];

  networking = {
    nameservers = [ "2a09::" "2a11::" "1.1.1.1" "8.8.8.8" ];
    dhcpcd.enable = false;
    defaultGateway = "23.26.226.1";
    defaultGateway6 = {
      address = "2602:fa11:40::1";
      interface = "ens3";
    };
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:40::"; prefixLength = 128; }
        ];
      };
      ens3 = {
        ipv4.addresses = [
          { address = "23.26.226.82"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2602:fa11:40:1015::a"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.40/24";
    ipv6 = "2602:feda:1bf:deaf::40/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
