{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAINxBkg8aE0DMS4ivYJ79mqBlQiPklHBKiJH2h8UuyVKAAAAAIFPmR7SJekBC4dtndppnnobWvXqjKLVYTqtfLW2YKN55AAAAAAAAAAAAAAACAAAAD3Zwc2RlZnJhbmtmdXJ0MQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACAYZ+H6MnIxlatIqP8xjSzySVF4apFpWgLC7lzHqXuGBgAAACEApzjM3EqLi9KuEVIO3/hY+GdPCR10xrJu+HPCXNjKiX8=";
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
    defaultGateway = "194.169.54.1";
    defaultGateway6 = "2a09:0:9::1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "194.169.54.18"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2a09:0:9::12e"; prefixLength = 48; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.28/24";
    ipv6 = "2602:feda:1bf:deaf::28/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}