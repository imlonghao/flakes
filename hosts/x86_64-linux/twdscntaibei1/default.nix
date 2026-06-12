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
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/mtrsb"
    "${self}/profiles/rsshc"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/bird.nix"
    "${self}/profiles/bird-lg-proxy"
    "${self}/profiles/komari-agent"
    # Containers
    "${self}/containers/snell.nix"
    "${self}/containers/globalping.nix"
  ];

  boot.loader.grub.device = "/dev/sda";
  networking = {
    dhcpcd.enable = false;
    defaultGateway = "103.147.22.254";
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    interfaces = {
      dummy = {
        virtual = true;
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.12";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2602:fab0:20::";
            prefixLength = 128;
          }
          {
            address = "2602:fab0:24::1";
            prefixLength = 128;
          }
          {
            address = "fd21:5c0c:9b7e:12::1";
            prefixLength = 128;
          }
        ];
      };
      ens18 = {
        ipv4.addresses = [
          {
            address = "103.147.22.112";
            prefixLength = 24;
          }
        ];
      };
      ens19 = {
        ipv6.addresses = [
          {
            address = "2a0f:5707:ffe3::89";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    rclone
    tmux
  ];

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
        lladdr 02:00:00:03:01:14
        ifconfig-ipv6 fe80::30:114 fe80::114:514
        secret ${config.sops.secrets.kskb-ix.path}
      '';
    };
  };

  sops.secrets.juicity.sopsFile = ./secrets.yml;
  services.juicity.enable = true;

  # ranet
  services.ranet = {
    enable = true;
    interface = "ens18";
    id = 12;
  };

  services.komari-agent.include-nics = [
    "ens18"
    "ens19"
  ];

  # LotSpeed
  services.lotspeed = {
    enable = true;
  };

}
