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
    "${self}/profiles/sing-box"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/pingfinder"
    "${self}/profiles/bird-lg-go"
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
      lo = {
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

  systemd.services."singbox-netns" = {
    description = "singbox network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeScript "netns-up" ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.iproute2}/bin/ip netns add singbox
        ${pkgs.iproute2}/bin/ip link add veth-sb-host type veth peer name veth-sb-ns
        ${pkgs.iproute2}/bin/ip link set veth-sb-ns netns singbox
        ${pkgs.iproute2}/bin/ip link set veth-sb-host up
        ${pkgs.iproute2}/bin/ip addr add 100.64.101.1/30 dev veth-sb-host
        ${pkgs.iproute2}/bin/ip -6 addr add 2602:fab0:24:c0ff::1/64 dev veth-sb-host
        ${pkgs.iproute2}/bin/ip -n singbox link set veth-sb-ns up
        ${pkgs.iproute2}/bin/ip -n singbox addr add 100.64.101.2/30 dev veth-sb-ns
        ${pkgs.iproute2}/bin/ip -n singbox -6 addr add 2602:fab0:24:c0ff::2/64 dev veth-sb-ns
        ${pkgs.iproute2}/bin/ip -n singbox ro add default via 100.64.101.1
        ${pkgs.iproute2}/bin/ip -n singbox -6 ro add default via 2602:fab0:24:c0ff::1
        ${pkgs.iproute2}/bin/ip -n singbox link set lo up
        ${pkgs.iproute2}/bin/ip -n singbox addr add 127.0.0.1/8 dev lo
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -d 103.147.22.112 -p udp --dport 443 -j DNAT --to-destination 100.64.101.2:443
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -d 103.147.22.112 -p tcp --dport 4443 -j DNAT --to-destination 100.64.101.2:4443
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -d 100.64.1.12 -p udp --dport 443 -j DNAT --to-destination 100.64.101.2:443
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 100.64.101.2 -j MASQUERADE
      '';
      ExecStop = pkgs.writeScript "netns-down" ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.iproute2}/bin/ip netns del singbox
        ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -d 103.147.22.112 -p udp --dport 443 -j DNAT --to-destination 100.64.101.2:443
        ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -d 103.147.22.112 -p tcp --dport 4443 -j DNAT --to-destination 100.64.101.2:4443
        ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -d 100.64.1.12 -p udp --dport 443 -j DNAT --to-destination 100.64.101.2:443
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 100.64.101.2 -j MASQUERADE
      '';
      PrivateMounts = false;
    };
  };
  systemd.services.sing-box = {
    bindsTo = [ "singbox-netns.service" ];
    after = [ "singbox-netns.service" ];
    serviceConfig = {
      NetworkNamespacePath = "/run/netns/singbox";
      PrivateNetwork = true;
    };
  };

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

}
