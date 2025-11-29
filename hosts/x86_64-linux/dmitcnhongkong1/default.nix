{ self, pkgs, ... }:
{
  imports = [
    ./dn42.nix
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/rsshc"
    "${self}/profiles/pingfinder"
    "${self}/profiles/bird-lg-go"
    "${self}/profiles/komari-agent"
    # Containers
    "${self}/containers/cloudflared.nix"
    "${self}/containers/snell.nix"
  ];

  boot.loader.grub.device = "/dev/vda";
  boot.kernelParams = [ "net.ifnames=0" ];

  systemd.network = {
    enable = true;
    networks.eth0 = {
      address = [ "154.3.37.101/32" ];
      matchConfig.Name = "eth0";
      routes = [
        {
          Gateway = "193.41.250.250";
          GatewayOnLink = true;
        }
      ];
    };
    networks.lo = {
      address = [
        "172.22.68.0/32"
        "172.22.68.3/32"
        "fd21:5c0c:9b7e:3::1/64"
      ];
      matchConfig.Name = "lo";
    };
  };
  networking = {
    useDHCP = false;
    nameservers = [
      "127.0.0.1"
      "1.1.1.1"
    ];
  };
  services.resolved.enable = false;

  environment.persistence."/persist" = {
    directories = [ "/var/lib" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  # ranet
  services.ranet = {
    enable = true;
    interface = "eth0";
    id = 30;
  };

  services.komari-agent = {
    month-rotate = 26;
    include-mountpoint = [ "/boot" ];
    include-nics = [ "eth0" ];
  };

  # Coredns
  services.coredns = {
    enable = true;
    config = ''
      . {
        bind 127.0.0.1
        forward . [2a09::]:53 [2a11::]:53 1.1.1.1:53 1.0.0.1:53 8.8.8.8:53 8.8.4.4:53
      }
      dn42 neo 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 10.in-addr.arpa d.f.ip6.arpa {
        bind 127.0.0.1
        forward . 172.20.0.53:53 172.23.0.53:53 [fd42:d42:d42:54::1]:53 [fd42:d42:d42:53::1]:53
      }
    '';
  };

  # LotSpeed
  services.lotspeed = {
    enable = true;
  };

  services.tailscale.enable = true;
  systemd.services.tailscale.serviceConfig = {
    ExecStartPost = [
      "${pkgs.iptables}/bin/iptables -t mangle -A PREROUTING -i tailscale0 -d 172.20.0.0/14 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source 172.22.68.3"
      "${pkgs.iptables}/bin/ip6tables -t mangle -A PREROUTING -i tailscale0 -d fd00::/8 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source fd21:5c0c:9b7e:3::1"
    ];
    ExecStopPost = [
      "${pkgs.iptables}/bin/iptables -t mangle -D PREROUTING -i tailscale0 -d 172.20.0.0/14 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source 172.22.68.3"
      "${pkgs.iptables}/bin/ip6tables -t mangle -D PREROUTING -i tailscale0 -d fd00::/8 -j MARK --set-mark 0x1888"
      "${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -m mark --mark 0x1888 -j SNAT --to-source fd21:5c0c:9b7e:3::1"
    ];
  };

}
