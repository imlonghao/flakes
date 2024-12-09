{ config, inputs, pkgs, profiles, sops, ... }:
let
  cronJob = pkgs.writeShellScript "199632.sh" ''
    ip rule | grep -F 23.146.88.0 || ip rule add from 23.146.88.0/24 table 199632
    ip -6 rule | grep -F 2602:fab0:31::/48 || ip -6 rule add from 2602:fab0:31::/48 table 199632
  '';
in {
  disabledModules = [ "services/backup/borgmatic.nix" ];

  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.docker
    profiles.rsshc
    profiles.exporter.node
    #    "${inputs.latest}/nixos/modules/services/backup/borgmatic.nix"
  ];

  boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [ "net.ifnames=0" ];
  nix.gc.dates = "monthly";

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "37.187.76.254";
    defaultGateway6 = {
      interface = "eth0";
      address = "2001:41d0:000a:2cff:00ff:00ff:00ff:00ff";
    };
    dhcpcd.enable = false;
    interfaces = {
      lo = {
        ipv4.addresses = [{
          address = "23.146.88.6";
          prefixLength = 32;
        }];
      };
      eth0 = {
        ipv4.addresses = [{
          address = "37.187.76.11";
          prefixLength = 24;
        }];
        ipv6.addresses = [{
          address = "2001:41d0:a:2c0b::1";
          prefixLength = 128;
        }];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ansible
    bgpq4
    borgbackup
    borgmatic
    croc
    deploy-rs
    dnsutils
    exploitdb
    ffmpeg
    git
    gitui
    go
    gobuster
    iptables
    lego
    jq
    just
    mcfly
    mediainfo
    metasploit
    moreutils
    mosh
    nali
    ncdu
    nix-update
    nixfmt
    nmap
    openssl
    openvpn
    (python3.withPackages (ps: with ps; [ requests ]))
    q
    rclone
    ripgrep
    rustic
    socat
    pkgs.sops
    step-cli
    tmux
    tree
    uv
    virt-manager
    whois
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.config"
      "/root/.ssh"
      "/root/.local"
      "/root/.ansible/"
    ];
    files = [ "/etc/machine-id" "/etc/ssh/ssh_host_ed25519_key" ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.24/24";
    ipv6 = "2602:feda:1bf:deaf::24/64";
  };

  # Corp SSH Public Key
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUNJVlqv8ZadxMk0XSlTpFmOHcxpbngu5GBZ9rSM77M Corp"
  ];

  # fish alias
  programs.fish.shellAliases = {
    nttcom = "whois -h rr.ntt.net";
    radb = "whois -h whois.radb.net";
  };

  # Docker
  virtualisation.docker = { storageDriver = "overlay2"; };

  # CronJob
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
      "5 12 * * * root bash -c 'cd /persist/archlinuxcn-pkgstats/ && bash cron.sh'"
      "* * * * * root ${cronJob} > /dev/null 2>&1"
      "* * * * * root /persist/random_email_sender/bin/run.py > /dev/null 2>&1"
    ];
  };

  # Borgmatic
  sops.secrets.borgmatic.sopsFile = ./secrets.yml;
  systemd.services.borgmatic.serviceConfig.EnvironmentFile =
    "/run/secrets/borgmatic";
  services.borgmatic = {
    enable = true;
    configurations = {
      ovh = {
        source_directories = [ "/persist/docker" ];
        exclude_patterns = [
          "/persist/docker/meilisearch/data.ms"
          "/persist/docker/bililive/*/"
          "/persist/docker/act_runner/data/.local"
          "/persist/docker/act_runner/data/cache"
        ];
        repositories = [{
          path = "ssh://q3924w6o@q3924w6o.repo.borgbase.com/./repo";
          label = "borgbase";
        }];
        encryption_passphrase = "\${FILEBROWSER_BORG_PASSPHRASE}";
        compression = "zstd";
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;
      };
    };
  };

  # KVM
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  virtualisation.libvirtd.enable = true;

  programs.fish.shellInit = ''
    ${pkgs.mcfly}/bin/mcfly init fish | source
  '';

  # Wrap
  sops.secrets.wrap.sopsFile = ./secrets.yml;
  networking.wireguard.interfaces.wrap = {
    table = "913335";
    privateKeyFile = config.sops.secrets.wrap.path;
    ips = [ "172.16.0.2/32" "2606:4700:110:899a:329c:9ece:ac7e:4b56/128" ];
    mtu = 1420;
    postSetup = [
      "${pkgs.iproute2}/bin/ip rule add from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule add from 133:35::/64 table 913335"
    ];
    postShutdown = [
      "${pkgs.iproute2}/bin/ip rule del from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule del from 133:35::/64 table 913335"
    ];
    peers = [{
      endpoint = "engage.cloudflareclient.com:2408";
      publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      persistentKeepalive = 15;
    }];
  };

}
