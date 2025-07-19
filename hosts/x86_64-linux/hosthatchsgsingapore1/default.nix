{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./dn42.nix
    ./hardware.nix
    ./bird.nix
    "${self}/profiles/borgmatic"
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/pingfinder"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/bird.nix"
    "${self}/profiles/docker"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/sing-box"
    "${self}/profiles/k3s/agent.nix"
  ];

  boot.loader.grub.device = "/dev/vda";
  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
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
          {
            address = "103.167.150.135";
            prefixLength = 24;
          }
        ];
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
            address = "fd21:5c0c:9b7e:2::1";
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

  environment.systemPackages = with pkgs; [
    rclone
    tmux
  ];

  environment.persistence."/persist" = {
    directories = [
      "/etc/rancher"
      "/root/.ssh"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
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
          to = [ "garage" ];
          cron = "0 1 * * *";
        };
      };
    };
  };

  # borgmatic
  systemd.services.borgmatic.path = [ pkgs.mariadb ];
  services.borgmatic.settings = {
    remote_path = "borg14";
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
    ];
  };

  # Incus
  virtualisation.incus.enable = true;

  # Wrap
  sops.secrets.wrap.sopsFile = ./secrets.yml;
  networking.wireguard.interfaces.wrap = {
    table = "913335";
    privateKeyFile = config.sops.secrets.wrap.path;
    ips = [
      "172.16.0.2/32"
      "2606:4700:110:8cd2:4dc2:3ed7:3305:10cd/128"
    ];
    mtu = 1420;
    postSetup = [
      "${pkgs.iproute2}/bin/ip rule add from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule add from 133:35::/64 table 913335"
    ];
    postShutdown = [
      "${pkgs.iproute2}/bin/ip rule del from 10.133.35.0/24 table 913335"
      "${pkgs.iproute2}/bin/ip -6 rule del from 133:35::/64 table 913335"
    ];
    peers = [
      {
        endpoint = "engage.cloudflareclient.com:2408";
        publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
        allowedIPs = [
          "0.0.0.0/0"
          "::/0"
        ];
        persistentKeepalive = 15;
      }
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens3";
    id = 17;
  };

}
