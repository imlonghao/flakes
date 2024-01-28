{ config, pkgs, profiles, sops, ... }:
{
  imports = [
    ./hardware.nix
    ./bird.nix
    profiles.mycore
    profiles.users.root
    profiles.etherguard.edge
    profiles.mtrsb
    profiles.netdata
    profiles.rsshc
  ];

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.147.22.254";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    interfaces = {
      lo = {
        ipv6.addresses = [
          { address = "2602:fab0:20::"; prefixLength = 128; }
          { address = "2602:fab0:24::"; prefixLength = 128; }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          { address = "103.147.22.112"; prefixLength = 24; }
        ];
      };
      ens19 = {
        ipv6.addresses = [
          { address = "2a0f:5707:ffe3::89"; prefixLength = 64; }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    rclone
    tmux
  ];

  # EtherGuard
  services.etherguard-edge = {
    ipv4 = "100.64.88.30/24";
    ipv6 = "2602:feda:1bf:deaf::30/64";
  };

  # OpenVPN
  sops.secrets.kskb-ix.sopsFile = ./secrets.yml;
  services.openvpn.servers = {
    kskb-ix = {
      config = ''
        port 8250
        dev kskb-ix
        cipher aes-256-cbc
        proto tcp-server
        dev-type tap
        keepalive 5 30
        persist-tun
        lladdr 02:00:00:19:96:32
        ifconfig-ipv6 fe80::199:632 fe80::114:514
        secret ${config.sops.secrets.kskb-ix.path}
      '';
    };
  };

  # netdata
  services.netdata = {
    enable = true;
    config = {
      global = {
        "memory mode" = "none";
      };
      health = {
        "enabled " = "no";
      };
    };
  };

  # Crontab
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 1 * * * root ${pkgs.git}/bin/git -C /persist/pki pull"
    ];
  };

  sops.secrets.juicity.sopsFile = ./secrets.yml;
  services.juicity.enable = true;

  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "tuic";
          listen = "::";
          listen_port = 443;
          users = [
            {
              name = "dummy";
              uuid = {
                _secret = "/persist/tuic.uuid";
              };
              password = {
                _secret = "/persist/tuic.password";
              };
            }
          ];
          congestion_control = "bbr";
          tls = {
            enabled = "true";
            server_name = {
              _secret = "/persist/tuic.sni";
            };
            certificate_path = "/persist/pki/.lego/certificates/esd.cc.crt";
            key_path = "/persist/pki/.lego/certificates/esd.cc.key";
          };
        }
      ];
    };
  };

}
