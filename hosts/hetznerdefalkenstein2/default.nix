{ config, pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIMuxuFzgbZ7XlC5Qj756ozb7Y4dx3HVSX86pQppLVBb6AAAAIBdPipWzQ9/RYt4p28d/H0e4U56zglZ4pdh4HiiifkjfAAAAAAAAAAAAAAACAAAAFWhldHpuZXJkZWZhbGtlbnN0ZWluMgAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACEAvNw+jmsymLBE6pXZG0K2TuzubjPxforUWumfOYxYYg0AAAAgfRBtnN671GM2at5sux3goI1zK/+Dzmw3q9PWFKo/bmg=";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    ./wireguard.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.teleport
    profiles.exporter.node
    profiles.exporter.bird
    profiles.k3s
    profiles.pingfinder
    profiles.autorestic
  ];

  nix.gc.dates = "monthly";

  boot.loader.grub.device = "/dev/sda";
  networking = {
    nameservers = [ "168.119.101.249" "1.1.1.1" ];
    defaultGateway = {
      interface = "enp0s31f6";
      address = "138.201.124.129";
    };
    defaultGateway6 = {
      interface = "enp0s31f6";
      address = "fe80::1";
    };
    interfaces = {
      enp0s31f6.ipv4.addresses = [
        {
          address = "138.201.124.182";
          prefixLength = 26;
        }
      ];
      enp0s31f6.ipv6.addresses = [
        {
          address = "2a01:4f8:172:27e4::";
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
    dnsutils
    docker-compose
    exploitdb
    file
    git
    gobuster
    lego
    metasploit
    ncdu
    nmap
    openssl
    openvpn
    python3
    python3Packages.requests
    ripgrep
    socat
    tmux
    tree
    whois
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/var/jfsCache"
      "/root/.ssh"
      "/root/.lego"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/rancher/node/password"
      "/etc/.autorestic.lock.yml"
    ];
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.12/24";
    ipv6 = "2602:feda:1bf:deaf::12/64";
  };

  # Teleport
  services.teleport.teleport.auth_token = "916c928451057889ad5d403985713b30";

  # rclone
  sops.secrets.rclone.sopsFile = ./secrets.yml;
  services.rclone-a = {
    enable = true;
    config = config.sops.secrets.rclone.path;
    from = "meesdcc:/";
    to = "/pt/meesdcc";
    cacheSize = "300G";
    before = [ "k3s.service" ];
  };

  # Deluge
  services.deluge = {
    enable = true;
    web.enable = true;
    openFilesLimit = 1048576;
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
        bind 2a01:4f8:172:27e4::
        forward . 127.0.0.1
        cache 30
      }
    '';
  };

  # fish alias
  programs.fish.shellAliases = {
    nttcom = "whois -h rr.ntt.net";
    radb = "whois -h whois.radb.net";
  };

  # owncast
  services.owncast = {
    enable = true;
    listen = "0.0.0.0";
  };

  # AutoRestic
  services.autorestic = {
    settings = {
      version = 2;
      global = {
        forget = {
          keep-hourly = 24;
          keep-daily = 7;
          keep-weekly = 4;
          keep-monthly = 6;
        };
      };
      backends = {
        garage = {
          type = "s3";
          path = "http://127.0.0.1:3900/restic";
        };
      };
      locations = {
        data = {
          from = [
            "/persist/docker/filebrowser"
            "/persist/docker/jellyfin"
            "/persist/docker/photoprism"
            "/persist/docker/trilium"
            "/persist/docker/vikunja/files"
            "/persist/docker/timetagger"
          ];
          to = [
            "garage"
          ];
          cron = "0 1 * * *";
        };
        etc = {
          from = [
            "/persist/etc"
          ];
          to = [
            "garage"
          ];
          cron = "0 1 * * *";
        };
      };
    };
  };

}
