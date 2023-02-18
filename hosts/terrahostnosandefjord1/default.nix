{ config, modulesPath, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIDHxSIMJ2nwx1qyk7WSeoaJrsk5M6EqDlAO1qWNMgczeAAAAIJm8dsdMwHmRwL2CpD1CnFvzZRcYNnKYbBQQxSVwMQGEAAAAAAAAAAAAAAACAAAAFnRlcnJhaG9zdG5vc2FuZGVmam9yZDEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGMAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEgAAAAgd0ucm2ODusFRly+FprvNCyNFSb4Esj1SpNwMRloN98AAAAAgRuCIoqZsjvVo3BFxTbspW44wbsAmrj1mmYL0gkSOBns=";
in
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.bird-lg-go
    profiles.vxwg
  ];

  # Network
  networking = {
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway = {
      interface = "ens18";
      address = "185.243.216.1";
    };
    defaultGateway6 = {
      interface = "ens18";
      address = "2a03:94e0:ffff:185:243:216::1";
    };
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "185.243.216.252";
          prefixLength = 24;
        }
      ];
      ens18.ipv6.addresses = [
        {
          address = "2a03:94e0:ffff:185:243:216::252";
          prefixLength = 118;
        }
      ];
      lo.ipv4.addresses = [
        { address = "172.22.68.0"; prefixLength = 32; }
        { address = "172.22.68.6"; prefixLength = 32; }
      ];
      lo.ipv6.addresses = [
        { address = "fd21:5c0c:9b7e:6::"; prefixLength = 64; }

        {
          address = "2602:feda:1bf::";
          prefixLength = 128;
        }
        {
          address = "2a09:b280:ff83::";
          prefixLength = 128;
        }
      ];
    };
  };

  # Boot
  boot.loader.grub.device = "/dev/sda";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.18/24";
    ipv6 = "2602:feda:1bf:deaf::18/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Docker
  virtualisation.docker.enable = true;

}
