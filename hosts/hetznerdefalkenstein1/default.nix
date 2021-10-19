{ pkgs, profiles, ... }:

{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.teleport
    profiles.rait
    profiles.exporter.node
    profiles.exporter.bird
    profiles.k3s
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
    };
  };

  environment.systemPackages = with pkgs; [
    dnsutils
    git
    git-crypt
    gobuster
    metasploit
    nmap
    openvpn
    socat
    tmux
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/run/secrets"
      "/root/.gnupg"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/rancher/node/password"
    ];
  };

  # profiles.rait
  services.gravity = {
    enable = true;
    address = "100.64.88.49/30";
    addressV6 = "2602:feda:1bf:a:d::1/80";
    hostAddress = "100.64.88.50/30";
    hostAddressV6 = "2602:feda:1bf:a:d::2/80";
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

}
