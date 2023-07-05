{ config, pkgs, profiles, self, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIAJ/IkOwFiHIVgc5HezpaI7Lenx4K6vyMd6Tm1zPiAgfAAAAIM5Olc8bKADYPDbK68y69bQG318sMB0Tko3dnebdF6YZAAAAAAAAAAAAAAACAAAADXR3ZHNjbnRhaWJlaTEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGQAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEkAAAAhANtk6engJ58g48aprha9O5S6P2kd1VlphnjtZA8OgtWjAAAAIGlb33r/PBfXFH/pUPAaqU2O/lAl0Lb0RIScuGLIDLKN";
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

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.147.22.254";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:24::"; prefixLength = 128; }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          { address = "103.147.22.112"; prefixLength = 24; }
        ];
      };
      ens19 = {
        ipv6.addresses = [
          { address = "2a0f:5707:ffe3::89"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.30/24";
    ipv6 = "2602:feda:1bf:deaf::30/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # OpenVPN
  sops.secrets.kskb-ix.sopsFile = ./secrets.yml;
  services.openvpn.servers = {
    kskb-ix = {
      config = ''
        port 8250
        dev kskb-ix
        cipher aes-256-cbc
        proto tcp-server
        dev-type tap
        keepalive 5 30
        persist-tun
        lladdr 02:00:00:19:96:32
        ifconfig-ipv6 fe80::199:632 fe80::114:514
        secret ${config.sops.secrets.kskb-ix.path}
      '';
    };
  };

}
