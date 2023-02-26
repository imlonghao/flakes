{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIDr86PxrJ+sO4HFCG5bLVqOLADQDeT/H8iZdmxkVfVbGAAAAIDgpJ4WTwRe6op9Qf8q1ObINJxyEl5U7maKWgMX27/QvAAAAAAAAAAAAAAACAAAAEG92aGZyZ3JhdmVsaW5lczEAAAAAAAAAAAAAAAD//////////wAAAAAAAAAAAAAAAAAAAGgAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAAhuaXN0cDI1NgAAAEEE7kbYJYQ4NWXoMkpjLfpyjonorXZj45+0JdSKGEam8pso0zn+8iY1PAPMDIIqspwzwNr7VZMgmchkz2qUsbxl1gAAAGMAAAATZWNkc2Etc2hhMi1uaXN0cDI1NgAAAEgAAAAgTdft+ANDOJA0Qb0UifxYfYn+mdiYTKi7iXUklqkQO6kAAAAgd0wrspRMsVGSY/fNriW1lfldG+qFBXFeOdYGGL/OPUQ=";
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
  ];

  boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "37.187.76.254";
    defaultGateway6 = {
      interface = "eth0";
      address = "2001:41d0:000a:2cff:00ff:00ff:00ff:00ff";
    };
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "37.187.76.11"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2001:41d0:a:2c0b::1"; prefixLength = 128; }
        ];
      };
    };
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

}
