{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIOpmCFiYlt9di4RO0E9i9wgBCNvjvwqdsUwnUJDlkSYHAAAAIOZmM7DOMHN4EAsviYmj0OYqqXEfciJZi5M6rnu2THVsAAAAAAAAAAAAAAACAAAAFHN0YXJyeWRuc2NuaG9uZ2tvbmcxAAAAAAAAAAAAAAAA//////////8AAAAAAAAAAAAAAAAAAABoAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdYAAABkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAABJAAAAIQCYIXoBYmtyTOf3+VHaoY2qBTut3Y/7vTHq9c7o5BmImQAAACBAtBFPGhHqtY87RECXS/xNqMhrfRrIK0Gb6NtyGHBAjw==";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.tuic
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.205.9.1";
    defaultGateway6 = "2403:ad80:98:c00::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      ens3.ipv4.addresses = [
        {
          address = "103.205.9.90";
          prefixLength = 24;
        }
      ];
      ens3.ipv6.addresses = [
        {
          address = "2403:ad80:98:c60::f6f4";
          prefixLength = 54;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "44.31.42.0";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "2a09:b280:ff81::";
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
      "/etc/rancher/node/password"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.6/24";
    ipv6 = "2602:feda:1bf:deaf::8/64";
  };

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 2403:ad80:98:c60::f6f4
        forward . 127.0.0.1
        cache 30
      }
    '';
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
