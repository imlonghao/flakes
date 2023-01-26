{ config, pkgs, profiles, sops, ... }:
let
  hostCertificate = pkgs.writeText "ssh_host_ed25519_key-cert.pub" "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAINUBBpFCjltGQ4wILUgWGcq8j+1lfOmrNtAmvSD4BTjNAAAAIBID8nCh4rMu4rhADLBjHR4zUvNWKF7898FHzkrBKY3CAAAAAAAAAAAAAAACAAAAFWhvc3RoYXRjaHNnc2luZ2Fwb3JlMQAAAAAAAAAAAAAAAP//////////AAAAAAAAAAAAAAAAAAAAaAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTuRtglhDg1ZegySmMt+nKOieitdmPjn7Ql1IoYRqbymyjTOf7yJjU8A8wMgiqynDPA2vtVkyCZyGTPapSxvGXWAAAAZAAAABNlY2RzYS1zaGEyLW5pc3RwMjU2AAAASQAAACBdEjzv5Cm6q0ithPhtehNlLOAcwVuclnnKeE2MI7qeNgAAACEAsNIW/oXN1w4V5TL8vvVvYgfDX6p4uZiPzvN5B2urIzg=";
in
{
  imports = [
    ./dn42.nix
    ./hardware.nix
    ./bird.nix
    profiles.borgmatic
    profiles.mycore
    profiles.netdata
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.docker
    profiles.autorestic
    profiles.bird-lg-go
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = {
      interface = "ens3";
      address = "103.167.150.1";
    };
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          { address = "103.167.150.135"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "2406:ef80:2:e::"; prefixLength = 64; }
          {
            address = "2406:ef80:2:e:114:514:1919:810";
            prefixLength = 64;
          }
        ];
      };
      lo = {
        ipv4.addresses = [
          { address = "172.22.68.2"; prefixLength = 32; }
          { address = "172.22.68.8"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "fd21:5c0c:9b7e:2::"; prefixLength = 64; }
          { address = "fd21:5c0c:9b7e::8"; prefixLength = 128; }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    rclone
    tmux
  ];

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

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.62/24";
    ipv6 = "2602:feda:1bf:deaf::6/64";
  };

  # OpenSSH
  services.openssh.extraConfig = ''
    HostCertificate = ${hostCertificate}
  '';

  services.powerdns = {
    enable = true;
    extraConfig = ''
      local-address=172.22.68.8,fd21:5c0c:9b7e::8
      launch=gmysql
      gmysql-password=234567
      webserver-address=0.0.0.0
      webserver-allow-from=0.0.0.0/0
      api=yes
      api-key=$scrypt$ln=10,p=1,r=8$xgVRGiRQT3XsFZOMo/WfSw==$VSWbInxkxV7Bu+SpHuCh3K99iS4PJY+LTRksHnRgKAM=
      default-soa-content=ns.imlonghao.dn42. hostmaster.@ 0 7200 1800 1209600 3600
    '';
  };
  systemd.services.pdns.after = [ "etherguard-edge.service" ];
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
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
          path = "https://s3.esd.cc/restic";
        };
      };
      locations = {
        data = {
          from = [
            "/persist/docker"
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

  # borgmatic
  services.borgmatic.settings = {
    location = {
      repositories = [
        "ssh://m0yiu24x@m0yiu24x.repo.borgbase.com/./repo"
        "ssh://zh2646@zh2646.rsync.net/./hosthatchsgsingapore1"
      ];
      source_directories = [
        "/persist/docker/baserow/backups"
        "/persist/docker/bitwarden"
        "/persist/docker/influxdb2"
        "/persist/docker/joplin.tgz"
        "/persist/docker/n8n/n8n.conf"
        "/persist/docker/traccar/traccar.xml"
        "/persist/docker/portainer"
        "/persist/docker/rathole"
        "/persist/docker/thelounge"
        "/persist/docker/traefik"
      ];
    };
    hooks = {
      before_backup = [
        "docker stop baserow-baserow-1"
        "docker run --rm -v /persist/docker/baserow/:/baserow/data/ baserow/baserow:1.9.1 backend-cmd-with-db backup"
      ];
      after_backup = [
        "docker start baserow-baserow-1"
        "rm -rf /persist/docker/baserow/backups"
      ];
      mysql_databases = [
        {
          name = "n8n";
          hostname = "127.0.0.1";
          port = 13306;
          username = "n8n";
          password = "\${N8N_PASSWORD}";
        }
        {
          name = "powerdns";
          hostname = "127.0.0.1";
          port = 3306;
          username = "powerdns";
          password = "234567";
        }
        {
          name = "traccar";
          hostname = "127.0.0.1";
          port = 13307;
          username = "traccar";
          password = "\${TRACCAR_PASSWORD}";
        }
      ];
    };
  };
}
