{ pkgs, profiles, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIDd+H+e1df2Ec5mpLPw6rqII/jYjUm3qzGI2MKUQqeAFAAAAICM0kX/ve5pvPbKCb+AHwZpxxDz4gEcRp6yvFyRr7nJxAAAAAAAAAAAAAAACAAAAFWhvc3RoYXRjaHNlc3RvY2tob2xtMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACBxvPo6Pf/YDIg6HRFURZF9ig7BYGmJQMqgHP7dMCoaYwAAACEAiTO4h68q+ab4BfvR4WiCFoX/vh/5pA8xMdLTmyI2vB4=";
in
{
  imports = [
    ./bird.nix
    ./borg.nix
    ./hardware.nix
    profiles.mycore
    profiles.netdata
    profiles.users.root
    profiles.etherguard.edge
    profiles.exporter.node
    profiles.mtrsb
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.allowInterfaces = [ "ens3" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    interfaces = {
      ens3 = {
        ipv6.addresses = [
          { address = "2a00:1a28:1157:f7da::1919"; prefixLength = 64; }
        ];
      };
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

  # Docker
  virtualisation.docker.enable = true;

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.16/24";
    ipv6 = "2602:feda:1bf:deaf::16/64";
  };

}
