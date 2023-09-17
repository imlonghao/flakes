{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIHZyYey1LCcKRsYerHf9w2B1irnK2jNaXn2b74J3H8mqAAAAIBSOTtTAYSdlCTVNwjmE5DU6NVSPiyoPcN6Y+i6/4qFSAAAAAAAAAAAAAAACAAAADWJ1eXZtdXNtaWFtaTEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGUAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEoAAAAhAIS5SJ2iqDirsAHpOdVc4R1unc8s5Hjp/qkI1UzS1TRaAAAAIQD6un0t6ejrn9ztVoOwf8ou6i/woUnAChietrc12ScGyQ==";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    # ./wireguard.nix
    profiles.mycore
    profiles.users.root
    # profiles.pingfinder
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.mtrsb
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "45.61.188.1";
    defaultGateway6 = "2605:6400:40::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        { address = "23.146.88.0"; prefixLength = 32; }
        { address = "23.146.88.1"; prefixLength = 32; }
      ];
      lo.ipv6.addresses = [
        { address = "2602:fab0:20::"; prefixLength = 128; }
        { address = "2602:fab0:2a::"; prefixLength = 128; }
        { address = "2602:fab0:2a:53::"; prefixLength = 128; }
      ];
      ens3.ipv4.addresses = [
        { address = "45.61.188.76"; prefixLength = 24; }
      ];
      ens3.ipv6.addresses = [
        { address = "2605:6400:40:fdeb::"; prefixLength = 48; }
      ];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
  environment.systemPackages = with pkgs; [
    iptables
  ];

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.70/24";
    ipv6 = "2602:feda:1bf:deaf::3/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # NAT64
  nat64 = {
    enable = true;
    gateway = "45.61.188.1";
    interface = "ens3";
    nat_start = "23.146.88.248";
    nat_end = "23.146.88.255";
    prefix = "2602:fab0:2a:";
    address = "23.146.88.1";
    location = "mia1";
  };

}
