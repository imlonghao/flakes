{ config, pkgs, profiles, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIMuxuFzgbZ7XlC5Qj756ozb7Y4dx3HVSX86pQppLVBb6AAAAIBdPipWzQ9/RYt4p28d/H0e4U56zglZ4pdh4HiiifkjfAAAAAAAAAAAAAAACAAAAFWhldHpuZXJkZWZhbGtlbnN0ZWluMgAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACEAvNw+jmsymLBE6pXZG0K2TuzubjPxforUWumfOYxYYg0AAAAgfRBtnN671GM2at5sux3goI1zK/+Dzmw3q9PWFKo/bmg=";
in
{
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.netdata
    profiles.users.root
    profiles.etherguard.edge
    profiles.exporter.node
    profiles.exporter.bird
    profiles.autorestic
    profiles.docker
  ];

  nix.gc.dates = "monthly";

  boot.loader.grub.device = "/dev/sda";
  networking = {
    nameservers = [ "127.0.0.1" "8.8.8.8" ];
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
    };
  };

  environment.systemPackages = with pkgs; [
    aria2
    buildtorrent
    deploy-rs
    dnsutils
    dumptorrent
    exploitdb
    fd
    ffmpeg
    file
    git
    gitui
    gobuster
    google-cloud-sdk
    httpie
    iptables
    lego
    just
    mediainfo
    metasploit
    mosh
    ncdu
    nmap
    openssl
    openvpn
    (python3.withPackages (ps: with ps; [ requests ]))
    q-dns
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
      "/root/.config/gcloud"
      "/root/.ssh"
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
    storageDriver = "overlay2";
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.12/24";
    ipv6 = "2602:feda:1bf:deaf::12/64";
  };

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
        bind 127.0.0.1
        forward . [2a09::]:53 [2a11::]:53 1.1.1.1:53 1.0.0.1:53 8.8.8.8:53 8.8.4.4:53
      }
      dn42 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 10.in-addr.arpa {
        bind 127.0.0.1
        forward . 172.20.0.53:53 172.23.0.53:53
      }
      d.f.ip6.arpa {
        bind 127.0.0.1
        forward . [fd42:d42:d42:54::1]:53 [fd42:d42:d42:53::1]:53
      }
    '';
  };

  # fish alias
  programs.fish.shellAliases = {
    nttcom = "whois -h rr.ntt.net";
    radb = "whois -h whois.radb.net";
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
            "/persist/syncthing"
            "/persist/lego"
            "/persist/root"
            "/jfs/checkssl"
            "/jfs/fava"
            "/jfs/pvc-bd601ea5-4e69-43a4-b2bc-ab73805cfbd8"
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

  # Databasebackup to local
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
      "5 12 * * * root bash -c 'cd /persist/archlinuxcn-pkgstats/ && bash cron.sh'"
    ];
  };

  # deluge_exporter
  services.deluge_exporter.enable = true;

  # Corp SSH Public Key
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUNJVlqv8ZadxMk0XSlTpFmOHcxpbngu5GBZ9rSM77M Corp"
  ];

}
