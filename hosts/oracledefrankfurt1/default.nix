{ modulesPath, pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIPxV2X/3y1IqlODxz8OMJxgv14yL/RDF/ezD4CHH4MoFAAAAIGPrYUbX2Zv3h9OfLjVu0H45ggfxX5SNLjZX+aEkUweKAAAAAAAAAAAAAAACAAAAEm9yYWNsZWRlZnJhbmtmdXJ0MQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZQAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASgAAACEA4lDqutOQ4OLZYthTZmia+36Z7sfveCEmiLaQxgZyG4oAAAAhAOSrLyY0Rt/jMHJzhyGf5XMSpnuSjTZU2wXOL2WGoPue";
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.exporter.node
    profiles.etherguard.edge
  ];

  # Config
  networking.dhcpcd.allowInterfaces = [ "eth0" ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.17/24";
    ipv6 = "2602:feda:1bf:deaf::17/64";
  };

  services.teleport.teleport.auth_token = "9ed1a7da7e91f1272a4ae229147efd54";

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBdCe7gSyrsOvU3iVa1gOIyvKD3NDyU0kVzCFRifcTIa root@nixos"
    ];
  };

}
