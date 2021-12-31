{ pkgs, profiles, ... }:

{
  imports = [
    ./bird.nix
    ./hardware.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.exporter.node
    profiles.exporter.bird
    profiles.k3s
    profiles.pingfinder
    profiles.etherguard.edge
  ];

  nix.gc.dates = "monthly";

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.allowInterfaces = [ "enp1s0" ];
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    defaultGateway6 = {
      interface = "enp1s0";
      address = "fe80::1";
    };
    interfaces = {
      enp1s0.ipv6.addresses = [
        {
          address = "2a01:4f8:c17:c8e3::";
          prefixLength = 64;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = "172.22.68.4";
          prefixLength = 32;
        }
      ];
      lo.ipv6.addresses = [
        {
          address = "fd21:5c0c:9b7e:4::";
          prefixLength = 64;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    acme-sh
    dnsutils
    docker-compose
    file
    git
    git-crypt
    gobuster
    lego
    metasploit
    nmap
    openvpn
    python3
    python3Packages.requests
    socat
    tmux
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.gnupg"
      "/root/.ssh"
      "/root/.lego"
      "/var/jfsCache"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/rancher/node/password"
    ];
  };

  services.teleport.teleport.auth_token = "fd64c74d419e690ab9d5cf99cf5b8b58";

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.50/24";
    ipv6 = "2602:feda:1bf:deaf::5/64";
  };

  # GPG
  programs.gnupg.agent.enable = true;

  # Coredns IPv6 forwarder
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 2a01:4f8:c17:c8e3::
        forward . 127.0.0.1
        cache 30
      }
    '';
  };

  # Docker
  virtualisation.docker.enable = true;

}
