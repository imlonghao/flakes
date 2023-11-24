{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAII8xif7vUE9UFKlLMO97k4z09+SM5LK7Y5biuh/nMrn4AAAAIDMeNpHpjcVVUDQcRXZSNFzLcNbMiaw2EWFHv3WYlhG0AAAAAAAAAAAAAAACAAAAEnN1YmxlZGtjb3BlbmhhZ2VuMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACAHlIO62oOngl060KlohNp94wqX6KccV/jDnBjf5Vyy1wAAACEAwbGNGVAfpBgIbJQum+ADnYeSS9FHDN6hK1ENEhrsy9M=";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.netdata
  ];

  networking = {
    nameservers = [ "2a09::" "2a11::" ];
    dhcpcd.enable = false;
    defaultGateway = "89.23.86.1";
    defaultGateway6 = "2001:67c:bec:a::1";
    interfaces = {
      lo = {
        ipv4.addresses = [
          { address = "23.146.88.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:32::"; prefixLength = 128; }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          { address = "89.23.86.39"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2001:67c:bec:a:a04c:ffff:fe90:8b81"; prefixLength = 64; }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          { address = "10.200.10.2"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "fd00:B990:19:96:32::1"; prefixLength = 64; }
        ];
      };
      eth2 = {
        ipv6.addresses = [
          { address = "2001:67c:bec:c7:0:19:9632:1"; prefixLength = 64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.38/24";
    ipv6 = "2602:feda:1bf:deaf::38/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
