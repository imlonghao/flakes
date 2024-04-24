{ inputs, pkgs, profiles, sops, ... }:
let
  cronJob = pkgs.writeShellScript "199632.sh" ''
    ip rule | grep -F 23.146.88.0 || ip rule add from 23.146.88.0/24 table 199632
    ip -6 rule | grep -F 2602:fab0:31::/48 || ip -6 rule add from 2602:fab0:31::/48 table 199632
  '';
in
{
  disabledModules = [
    "services/backup/borgmatic.nix"
    "services/monitoring/netdata.nix"
  ];

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
    "${inputs.latest}/nixos/modules/services/monitoring/netdata.nix"
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
        ipv4.addresses = [
          { address = "23.146.88.6"; prefixLength = 32; }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          { address = "37.187.76.11"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2001:41d0:a:2c0b::1"; prefixLength = 128; }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
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
    gobuster
    iptables
    lego
    just
    mediainfo
    metasploit
    mosh
    ncdu
    netdata
    nix-update
    nmap
    openssl
    openvpn
    (python3.withPackages (ps: with ps; [ requests ]))
    q
    rclone
    ripgrep
    socat
    step-cli
    tmux
    tree
    virt-manager
    whois
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.ssh"
      "/root/.local"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
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
  virtualisation.docker = {
    storageDriver = "overlay2";
  };

  # CronJob
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
      "5 12 * * * root bash -c 'cd /persist/archlinuxcn-pkgstats/ && bash cron.sh'"
      "* * * * * root ${cronJob} > /dev/null 2>&1"
    ];
  };

  # netdata
  services.netdata = {
    enable = true;
    package = pkgs.netdataCloud;
    config = {
      web = {
        "bind to" = "100.64.88.24";
      };
      logs = {
        "severity level" = "error";
      };
      health = {
        "enabled alarms" = "!30min_ram_swapped_out *";
      };
    };
    configDir = {
      "stream.conf" =  pkgs.writeText "stream.conf" ''
        [040ed080-a060-4a06-ace3-c49408623721]
        enabled = yes
        type = api
        allow from = 100.64.88.*
      '';
    };
  };
  systemd.services.netdata.after = [ "etherguard-edge.service" ];
  
  # Borgmatic
  sops.secrets.borgmatic.sopsFile = ./secrets.yml;
  systemd.services.borgmatic.serviceConfig.EnvironmentFile = "/run/secrets/borgmatic";
  services.borgmatic = {
    enable = true;
    configurations = {
      photoprism = {
        source_directories = [
          "/persist/docker/photoprism"
        ];
        repositories = [
          { path="ssh://bln02xkt@bln02xkt.repo.borgbase.com/./repo"; label="borgbase"; }
        ];
        encryption_passphrase = "\${PHOTOPRISM_BORG_PASSPHRASE}";
        compression = "zstd";
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;
      };
      filebrowser = {
        source_directories = [
          "/persist/docker/filebrowser"
        ];
        repositories = [
          { path="ssh://v5zl57p2@v5zl57p2.repo.borgbase.com/./repo"; label="borgbase"; }
        ];
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

}
