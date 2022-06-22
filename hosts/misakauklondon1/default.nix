{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIF5R0puQdWjwJy2Kw+f+V/iBcNVpBhZVGWtDChBSjdgBAAAAIACWZZuSUOUNdTSSFS1q0fGtvE3ddC4MyXPDHBLcZ/kdAAAAAAAAAAAAAAACAAAAD21pc2FrYXVrbG9uZG9uMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACAuL6TdxpoAj+hvvETN7IULr5qHo8qOYMI+A0nitu4SigAAACEA6iSwItRH+FwJQO3ahq3iMCNC0QanQ2CgPL57nlGxTxU=";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.exporter.node
    profiles.etherguard.super
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "enp3s0" ];
    interfaces = {
      lo.ipv4.addresses = [
        {
          address = "44.31.42.0";
          prefixLength = 32;
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

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  services.myteleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # Docker
  virtualisation.docker.enable = true;

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.74/24";
    ipv6 = "2602:feda:1bf:deaf::1/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        forward . 138.201.124.182
        cache 30
      }
    '';
  };

}
