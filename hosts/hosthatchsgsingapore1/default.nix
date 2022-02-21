{ config, pkgs, profiles, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAINUBBpFCjltGQ4wILUgWGcq8j+1lfOmrNtAmvSD4BTjNAAAAIBID8nCh4rMu4rhADLBjHR4zUvNWKF7898FHzkrBKY3CAAAAAAAAAAAAAAACAAAAFWhvc3RoYXRjaHNnc2luZ2Fwb3JlMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACBdEjzv5Cm6q0ithPhtehNlLOAcwVuclnnKeE2MI7qeNgAAACEAsNIW/oXN1w4V5TL8vvVvYgfDX6p4uZiPzvN5B2urIzg=";
in
{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.pingfinder
    # profiles.coredns.dn42
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  # networking.defaultGateway6 = {
  #   address = "2406:ef80:2::1";
  # };
  # networking.interfaces.ens3.ipv6.addresses = [
  #   {
  #     address = "2406:ef80:2:e::";
  #     prefixLength = 48;
  #   }
  # ];
  networking.interfaces.lo.ipv4.addresses = [
    {
      address = "172.22.68.2";
      prefixLength = 32;
    }
  ];
  networking.interfaces.lo.ipv6.addresses = [
    {
      address = "fd21:5c0c:9b7e:2::";
      prefixLength = 64;
    }
  ];

  environment.systemPackages = with pkgs; [
    rclone
    tmux
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/var/jfsCache"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.62/24";
    ipv6 = "2602:feda:1bf:deaf::6/64";
  };

  # k3s server
  services.k3s = {
    enable = true;
    role = "server";
  };
  services.k3s-no-ctstate-invalid.enable = true;

  # fish alias
  programs.fish.shellAliases = {
    k = "k3s kubectl";
  };

  # Docker
  virtualisation.docker.enable = true;

  # rclone
  sops.secrets.rclone.sopsFile = ./secrets.yml;
  services.rclone-a = {
    enable = true;
    config = config.sops.secrets.rclone.path;
    from = "meesdcc:/BilibiliLiveRecord";
    to = "/persist/docker/jellyfin/media/bililive";
    before = [ "k3s.service" ];
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  services.powerdns = {
    enable = true;
    extraConfig = ''
      launch=gmysql
      gmysql-password=234567
      webserver-address=0.0.0.0
      webserver-allow-from=127.0.0.1,::1,100.64.88.0/24
      api=yes
      api-key=123456
    '';
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

}
