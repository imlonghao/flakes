{ config, pkgs, profiles, self, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIINVs+LD+1BP0deuPA07tuoYVMlQftbmiZIbdv4K5sfzAAAAICoi3lWKYf9PdO/c9uSf5rty9CdjU9Sr14UuF9HPRdCXAAAAAAAAAAAAAAACAAAAD3Z1bHRydXNzZWF0dGxlMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEAuX2/V4UwPirHl7Ub7i7S4yVjDSkYgAP+z0BhTJjBWpoAAAAhAMzWxwAEkbFBuVa7dxFSuhCILeGqSjgfVbI1vSZkdUl0";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
  ];

  zramSwap.enable = true;

  networking = {
    interfaces = {
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:25::"; prefixLength = 128; }
        ];
      };
      enp1s0.useDHCP = true;
    };
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.32/24";
    ipv6 = "2602:feda:1bf:deaf::32/64";
  };

}
