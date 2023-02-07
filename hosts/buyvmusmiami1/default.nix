{ pkgs, profiles, ... }:
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
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    defaultGateway6 = "2605:6400:40::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        { address = "23.146.88.0"; prefixLength = 32; }
        { address = "44.31.42.0"; prefixLength = 32; }
      ];
      lo.ipv6.addresses = [
        { address = "2602:fab0:10::"; prefixLength = 128; }
        { address = "2602:fab0:10:53::"; prefixLength = 128; }
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

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.70/24";
    ipv6 = "2602:feda:1bf:deaf::3/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Tayga
  services.tayga = {
    enable = true;
    ipv4 = {
      address = "45.61.188.76";
      router.address = "100.110.0.1";
      pool = {
        address = "100.110.0.0";
        prefixLength = 16;
      };
    };
    ipv6 = {
      address = "2602:fab0:10::";
      router.address = "2602:fab0:10:64::1";
      pool = {
        address = "2602:fab0:10:64::";
        prefixLength = 96;
      };
    };
  };

}
