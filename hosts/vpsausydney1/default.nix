{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIB7S04bKMDxbXjfE04+EiHiyP5E6F7+v1EDygUGZGCYZAAAAIPj+1xs73sqX0ReBy336QHxcgCe9v9chEDKjswjGyDXWAAAAAAAAAAAAAAACAAAADHZwc2F1c3lkbmV5MQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEAyB0Z36xiuKJo51w0RIekBxmXAyuNPt6WYTXqsddWSUwAAAAhALBlc+6usdyXE5jvSCb3J0Xk6MH/A02Lu8VpcKPSp3Af";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.bird-lg-go
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "185.222.217.1";
    defaultGateway6 = "2a11:3:101::1";
    dhcpcd.enable = false;
    interfaces = {
      enp6s18 = {
        ipv4.addresses = [
          { address="185.222.217.139"; prefixLength=24; }
        ];
        ipv6.addresses = [
          { address="2a11:3:101::105b"; prefixLength=48; }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address="172.22.68.9"; prefixLength=32; }
        ];
        ipv6.addresses = [
          { address="fd21:5c0c:9b7e:9::"; prefixLength=64; }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.22/24";
    ipv6 = "2602:feda:1bf:deaf::22/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
