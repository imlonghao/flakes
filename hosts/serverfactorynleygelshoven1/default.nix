{ config, lib, pkgs, profiles, self, ... }: {
  imports = [
    ./bird.nix
    ./hardware.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.exporter.node
    profiles.rsshc
    profiles.qemuGuest
    profiles.docker
    profiles.k3s.server
  ];

  networking = {
    nameservers = [ "2a09::" "2a11::" "8.8.8.8" "1.1.1.1" ];
    dhcpcd.enable = false;
    defaultGateway = "31.41.249.1";
    defaultGateway6 = "2a07:e042::1";
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "23.146.88.0";
            prefixLength = 32;
          }
          {
            address = "23.146.88.7";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:30::";
            prefixLength = 128;
          }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          {
            address = "31.41.249.39";
            prefixLength = 24;
          }
          {
            address = "192.168.112.3";
            prefixLength = 31;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a07:e042:1:47::1";
            prefixLength = 32;
          }
          {
            address = "fd74:e849:e9bc:ee83::15";
            prefixLength = 127;
          }
        ];
      };
    };
  };

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.37/24";
    ipv6 = "2602:feda:1bf:deaf::37/64";
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs =
      [ "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull" ];
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
