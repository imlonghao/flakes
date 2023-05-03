{ pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIF5R0puQdWjwJy2Kw+f+V/iBcNVpBhZVGWtDChBSjdgBAAAAIACWZZuSUOUNdTSSFS1q0fGtvE3ddC4MyXPDHBLcZ/kdAAAAAAAAAAAAAAACAAAAD21pc2FrYXVrbG9uZG9uMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACAuL6TdxpoAj+hvvETN7IULr5qHo8qOYMI+A0nitu4SigAAACEA6iSwItRH+FwJQO3ahq3iMCNC0QanQ2CgPL57nlGxTxU=";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.borgmatic
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.super
    profiles.etherguard.edge
    profiles.mtrsb
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = {
      interface = "enp3s0";
      address = "100.100.0.0";
    };
    defaultGateway6 = {
      interface = "enp3s0";
      address = "fe80::1";
    };
    dhcpcd.enable = false;
    interfaces = {
      enp3s0 = {
        ipv4.addresses = [
          { address = "45.142.244.141"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a0f:3b03:101:12:5054:ff:fe16:e83c"; prefixLength = 64; }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address = "44.31.42.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2602:feda:1bf::"; prefixLength = 128; }
          { address = "2a09:b280:ff85::"; prefixLength = 128; }
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

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Docker
  virtualisation.docker.enable = true;

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.74/24";
    ipv6 = "2602:feda:1bf:deaf::1/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        forward . 138.201.124.182
        cache 30
      }
    '';
  };

  # borgmatic
  services.borgmatic.settings = {
    location = {
      repositories = [
        "ssh://sxvl8201@sxvl8201.repo.borgbase.com/./repo"
        "ssh://zh2646@zh2646.rsync.net/./misakauklondon1"
      ];
      source_directories = [
        "/persist/pomerium"
      ];
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

}
