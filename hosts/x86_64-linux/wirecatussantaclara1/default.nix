{ self, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/docker"
    "${self}/profiles/borgmatic"
    "${self}/profiles/etcd"
    "${self}/profiles/komari-agent"
  ];

  boot.kernelParams = [
    "audit=0"
    "net.ifnames=0"
  ];
  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = {
      address = "169.254.0.1";
      interface = "eth0";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "45.45.224.73";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fc52:10e:e384::2";
            prefixLength = 128;
          }
        ];
      };
      dummy = {
        virtual = true;
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:23::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:23::25";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib"
      "/root/.ssh"
      "/root/.cache/rustic"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # Borgmatic
  systemd.services.borgmatic.path = [ pkgs.mariadb ];
  services.borgmatic.settings = {
    repositories = [
      {
        path = "ssh://alb8ug6d@alb8ug6d.repo.borgbase.com/./repo";
        label = "borgbase";
      }
    ];
    source_directories = [
      "/mnt/"
    ];
    commands = [
      {
        after = "everything";
        when = [ "create" ];
        run = [
          "${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://pulse.updown.io/qh7z/N4H6VSdK"
        ];
        states = [ "finish" ];
      }
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 18;
  };

  services.cert-syncer = {
    enable = true;
    wishlist = [ "go9mail.com" ];
  };

  # komari-agent
  services.komari-agent = {
    include-nics = [ "eth0" ];
  };

  # rustic
  sops.secrets.rustic.sopsFile = ./secrets.yml;
  systemd.services.rustic = {
    serviceConfig = {
      ExecStart = [
        "${pkgs.rustic}/bin/rustic backup /mnt"
        "${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null https://pulse.updown.io/lyym/TwBLKtyL"
      ];
      Type = "oneshot";
      EnvironmentFile = "/run/secrets/rustic";
    };
  };
  systemd.timers.rustic = {
    timerConfig = {
      OnCalendar = "daily";
      Persistent = "true";
      RandomizedDelaySec = "8h";
    };
    wantedBy = [ "timers.target" ];
  };

}
