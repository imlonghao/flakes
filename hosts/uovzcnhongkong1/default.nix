{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_rsa_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAICw6tK6fZm95OSlhItaDx5PmyelMSRc3ZDTDyFKTE0YqAAAAIFLUpy8RTdbWL3SeKpladeChdgCZz2rIVrRgr2POqc+jAAAAAAAAAAAAAAACAAAAD3Vvdnpjbmhvbmdrb25nMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAYwAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASAAAACAG5W1Wsjv/HAQXajc9wu2blaCJoVXrfTkvifql4CTv1gAAACAMfBIp2WDzAgdPauB8fCRobVnoel/9kEhsf3gD3V2Qcw==";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.k3s
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.200.114.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      ens3.ipv4.addresses = [
        {
          address = "103.200.114.26";
          prefixLength = 25;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "172.22.68.3";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:3::";
          prefixLength = 64;
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

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.10/24";
    ipv6 = "2602:feda:1bf:deaf::9/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
