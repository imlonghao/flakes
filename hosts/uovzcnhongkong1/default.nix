{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAICw6tK6fZm95OSlhItaDx5PmyelMSRc3ZDTDyFKTE0YqAAAAIFLUpy8RTdbWL3SeKpladeChdgCZz2rIVrRgr2POqc+jAAAAAAAAAAAAAAACAAAAD3Vvdnpjbmhvbmdrb25nMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAYwAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASAAAACAG5W1Wsjv/HAQXajc9wu2blaCJoVXrfTkvifql4CTv1gAAACAMfBIp2WDzAgdPauB8fCRobVnoel/9kEhsf3gD3V2Qcw==";
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
    profiles.mtrsb
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.200.115.254";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      eth0.ipv4.addresses = [
        {
          address = "103.200.115.22";
          prefixLength = 24;
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
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.10/24";
    ipv6 = "2602:feda:1bf:deaf::9/64";
  };
  systemd.services.etherguard-edge.serviceConfig = {
    ExecStartPost = [
      "${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 100.64.88.19 -o eth0 -j SNAT --to-source 103.200.115.22"
    ];
    ExecStopPost = [
      "${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 100.64.88.19 -o eth0 -j SNAT --to-source 103.200.115.22"
    ];
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
