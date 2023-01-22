{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIOXt5Ky4HgllBx6lN2qr+0zYXeMYt5+e8SnwUlSYUYQfAAAAIF3/kKhE8t/be9VMk7RJgd9/anolFA/bksy+Hs8Kc6/rAAAAAAAAAAAAAAACAAAAD21pc2FrYWRlYmVybGluMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAYwAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASAAAACADA7ypUvCpnibnSRdLL9H/fYcxMqQMz3alEVyoamOqbwAAACAPu2XuPY7bMhWmlr1PhQ6DgS7wF1XDxFlJRTIBE4iq8w==";
in
{
  imports = [
    ./hardware.nix
    profiles.mycore
    profiles.users.root
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = {
      interface = "eth0";
      address = "100.100.0.0";
    };
    dhcpcd.enable = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "45.142.247.152"; prefixLength = 32; }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/root/.ssh"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';
}