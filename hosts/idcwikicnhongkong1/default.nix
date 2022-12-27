{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIFES/8d8ljwk6rj7j/kR5MJIHBnCXm3/jm6MQx2/Wn0YAAAAIDY1j0nEaXQ1i0FgVL8B5ZGWWNKWV5YoUIfpPEK9qUmvAAAAAAAAAAAAAAACAAAAEmlkY3dpa2ljbmhvbmdrb25nMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAYwAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASAAAACAL1Jl9tRsF8+Lm99C9x9XBGM/CuIqxKgGrYByKc+pcUAAAACB24ERHoY1YeaJgi2APAiRrGTZ0EsP1j7zAxpnyPb8ZdA==";
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.netdata
    profiles.users.root
  ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "178.253.52.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "178.253.52.63"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2405:f3c0:1:8659::1"; prefixLength = 64; }
        ];
      };
    };
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

}
