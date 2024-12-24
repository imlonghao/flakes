{ config, lib, profiles, self, ... }: {
  imports = [
    ./dn42.nix
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.exporter.node
    profiles.etherguard.edge
    profiles.rsshc
    profiles.pingfinder
    profiles.docker
    profiles.bird-lg-go
  ];

  networking = {
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.3";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [{
          address = "fd21:5c0c:9b7e:3::";
          prefixLength = 64;
        }];
      };
    };
    dhcpcd.allowInterfaces = [ "ens5" ];
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.43/24";
    ipv6 = "2602:feda:1bf:deaf::43/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull" ];
  };

  # Realm
  services.realm = {
    enable = true;
    config = {
      endpoints = [
        {
          listen = "0.0.0.0:443";
          remote = "157.254.178.55:443";
          network = {
            no_tcp = true;
            use_udp = true;
          };
        }
        {
          listen = "0.0.0.0:8443";
          remote = "103.147.22.112:443";
          network = {
            no_tcp = true;
            use_udp = true;
          };
        }
        {
          listen = "0.0.0.0:3389";
          remote = "157.254.178.55:9102";
        }
      ];
    };
  };

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
