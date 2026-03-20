{ self, pkgs, ... }:
{
  imports = [
    ./bird.nix
    ./dn42.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/exporter/blackbox.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/mtrsb"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/komari-agent"
    # Containers
    "${self}/containers/snell.nix"
    "${self}/containers/globalping.nix"
  ];

  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    defaultGateway = "193.32.148.1";
    defaultGateway6 = "2a12:a301:2013::1";
    dhcpcd.enable = false;
    interfaces = {
      lo = {
        ipv4.addresses = [
          {
            address = "172.22.68.0";
            prefixLength = 32;
          }
          {
            address = "172.22.68.10";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd21:5c0c:9b7e:10::1";
            prefixLength = 64;
          }
        ];
      };
      eth0 = {
        ipv4.addresses = [
          {
            address = "193.32.149.99";
            prefixLength = 22;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a12:a301:2013::109a";
            prefixLength = 48;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wgcf
    wireguard-tools
  ];

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 10;
  };

  # komari-agent
  services.komari-agent = {
    month-rotate = 20;
    include-nics = [ "eth0" ];
  };

  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig = {
    ExecStartPost = [
      "${pkgs.iptables}/bin/iptables -t mangle -A PREROUTING -i tailscale0 -d 172.20.0.0/14 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source 172.22.68.10"
      "${pkgs.iptables}/bin/ip6tables -t mangle -A PREROUTING -i tailscale0 -d fd00::/8 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source fd21:5c0c:9b7e:10::1"
    ];
    ExecStopPost = [
      "${pkgs.iptables}/bin/iptables -t mangle -D PREROUTING -i tailscale0 -d 172.20.0.0/14 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source 172.22.68.10"
      "${pkgs.iptables}/bin/ip6tables -t mangle -D PREROUTING -i tailscale0 -d fd00::/8 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source fd21:5c0c:9b7e:10::1"
    ];
  };

}
