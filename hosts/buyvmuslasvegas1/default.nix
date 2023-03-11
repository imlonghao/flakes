{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAILO36UxjMudDcAgQ1V/TEm2rMb7fxuhOg2T6ulm/vva2AAAAICnnJaYAhSql7Ecf0SvKJLrMiE6NFFc4OvJ457Xt3NnOAAAAAAAAAAAAAAACAAAAEGJ1eXZtdXNsYXN2ZWdhczEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGUAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEoAAAAhAJHjZArrKt+jB7tg0k0Q6fIArDEbTi+lGB4ZreQYvITvAAAAIQCT9NUeldc/Xu65twVJd3VRmtDcSopVPGNC02fuV3SgNA==";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./dn42.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.bird-lg-go
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    defaultGateway6 = "2605:6400:20::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "172.22.68.5";
          prefixLength = 32;
        }
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
        {
          address = "23.146.88.0";
          prefixLength = 32;
        }
        {
          address = "23.146.88.3";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:5::";
          prefixLength = 64;
        }
        {
          address = "2a09:b280:ff82::";
          prefixLength = 48;
        }
      ];
      ens3.ipv6.addresses = [
        {
          address = "2605:6400:20:803::";
          prefixLength = 48;
        }
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
    ipv4 = "100.64.88.66/24";
    ipv6 = "2602:feda:1bf:deaf::2/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  networking.hosts = {
    "240e:945:7:e::1" = [ "api.bilibili.com" ];
    "240e:97d:2000:300::7" = [ "api.live.bilibili.com" ];
  };

}
