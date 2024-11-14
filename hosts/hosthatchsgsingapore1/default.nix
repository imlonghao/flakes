{ config, lib, pkgs, profiles, sops, ... }: {
  imports = [
    ./dn42.nix
    ./hardware.nix
    ./bird.nix
    profiles.borgmatic
    profiles.mycore
    profiles.users.root
    profiles.pingfinder
    profiles.exporter.node
    profiles.exporter.bird
    profiles.etherguard.edge
    profiles.docker
    profiles.bird-lg-go
    profiles.mtrsb
    profiles.rsshc
    profiles.sing-box
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
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
        ipv4.addresses = [{
          address = "103.167.150.135";
          prefixLength = 24;
        }];
        ipv6.addresses = [
          {
            address = "2406:ef80:2:e::1";
            prefixLength = 64;
          }
          {
            address = "2406:ef80:2:e:114:514:1919:810";
            prefixLength = 64;
          }
        ];
      };
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.2";
            prefixLength = 32;
          }
          {
            address = "172.22.68.8";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:2::";
            prefixLength = 64;
          }
          {
            address = "fd21:5c0c:9b7e::8";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ rclone tmux ];

  environment.persistence."/persist" = {
    directories = [ "/root/.ssh" "/var/lib" ];
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

  services.powerdns = {
    enable = true;
    extraConfig = ''
      local-address=172.22.68.8,fd21:5c0c:9b7e::8
      launch=gmysql
      gmysql-password=234567
      webserver-address=0.0.0.0
      webserver-allow-from=0.0.0.0/0
      api=yes
      api-key=$scrypt$ln=10,p=1,r=8$OjP/EwduSv/8CCwZA6j7oQ==$gALD1NXVNOg9braM68SZ/5W/SZZ8wDm8AUtbH3AlVe4=
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
          from = [ "/persist/docker" "/persist/etc" ];
          to = [ "garage" ];
          cron = "0 1 * * *";
        };
      };
    };
  };

  # borgmatic
  systemd.services.borgmatic.path = [ pkgs.mariadb ];
  services.borgmatic.settings = {
    repositories = [
      {
        path = "ssh://m0yiu24x@m0yiu24x.repo.borgbase.com/./repo";
        label = "borgbase";
      }
      {
        path = "ssh://zh2646@zh2646.rsync.net/./hosthatchsgsingapore1";
        label = "rsync";
      }
    ];
    source_directories = [
      "/persist/docker/bitwarden"
      "/persist/docker/influxdb2"
      "/persist/docker/n8n/n8n.conf"
      "/persist/docker/traccar/traccar.xml"
      "/persist/docker/portainer"
      "/persist/docker/rathole"
      "/persist/docker/thelounge"
      "/persist/docker/traefik"
    ];
    mariadb_databases = [
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

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull" ];
  };

  # Incus
  virtualisation.incus.enable = true;

  # Vector
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        docker = {
          type = "docker_logs";
          include_containers = [ "caddy" ];
        };
      };
      transforms = {
        parse_json = {
          type = "remap";
          inputs = [ "docker" ];
          source = ''
            . = parse_json!(.message)
            .hostname = get_hostname!()
          '';
        };
      };
      sinks = {
        caddycdn = {
          type = "http";
          inputs = [ "parse_json" ];
          uri = "https://o2.esd.cc/api/default/caddycdn/_json";
          method = "post";
          auth.strategy = "basic";
          auth.user = "\${O2_USER-default}";
          auth.password = "\${O2_PASSWORD-default}";
          compression = "gzip";
          encoding.codec = "json";
          encoding.timestamp_format = "rfc3339";
          healthcheck.enabled = false;
        };
      };
    };
  };
  sops.secrets.openobserve = { sopsFile = "${self}/secrets/openobserve.yml"; };
  systemd.services.vector.serviceConfig = {
    EnvironmentFile = config.sops.secrets.openobserve.path;
    DynamicUser = lib.mkForce false;
  };

}
