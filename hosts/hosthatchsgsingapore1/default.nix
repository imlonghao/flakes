{ config, pkgs, profiles, sops, ... }:

{
  imports = [
    ./hardware.nix
    ./bird.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.pingfinder
    profiles.coredns.dn42
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
  ];

  boot.loader.grub.device = "/dev/vda";
  networking.dhcpcd.allowInterfaces = [ "ens3" ];
  networking.defaultGateway6 = {
    address = "2406:ef80:2::1";
  };
  networking.interfaces.ens3.ipv6.addresses = [
    {
      address = "2406:ef80:2:e::";
      prefixLength = 48;
    }
  ];
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
  sops.secrets.rclone.sopsFile = "./secrets.yml";
  services.rclone-a = {
    enable = true;
    config = config.sops.secrets.rclone.path;
    from = "meesdcc:/BilibiliLiveRecord";
    to = "/persist/docker/jellyfin/media/bililive";
    before = [ "k3s.service" ];
  };

}
