{ config, pkgs, profiles, self, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAILsy3ktfbPXRIkckHB6g9IT8uRS6AQtaMZUzpkLt/8DGAAAAIIjq55+asSmNMn2LxQmC6JbIvtXb0A156TPQ0F9hn0f0AAAAAAAAAAAAAAACAAAAG3NlcnZlcmZhY3RvcnlubGV5Z2Vsc2hvdmVuMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEA9qjmTwYShxfIW41X3msLQoxTTxmnHM3RaY9GPoYbtx0AAAAhAK0yRkpGERurPB91mn51URsr+Hauromhag3/gd3qYkiF";
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
    nameservers = [ "2609::" "2a11::" ];
    dhcpcd.enable = false;
    defaultGateway = "31.41.249.1";
    defaultGateway6 = "2a07:e042::1";
    interfaces = {
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:30::"; prefixLength = 128; }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          { address = "31.41.249.39"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2a07:e042:1:47::1"; prefixLength = 32; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.37/24";
    ipv6 = "2602:feda:1bf:deaf::37/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
