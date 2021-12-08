{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.74;
      timeformat protocol iso long;
      protocol direct {
        ipv4;
        ipv6;
        interface "gravity";
      }
      protocol device {
        scan time 10;
      }
      function is_valid_network() {
        return net ~ [
          172.20.0.0/14{21,29}, # dn42
          172.20.0.0/24{28,32}, # dn42 Anycast
          172.21.0.0/24{28,32}, # dn42 Anycast
          172.22.0.0/24{28,32}, # dn42 Anycast
          172.23.0.0/24{28,32}, # dn42 Anycast
          172.31.0.0/16+,       # ChaosVPN
          10.100.0.0/14+,       # ChaosVPN
          10.127.0.0/16{16,32}, # neonetwork
          10.0.0.0/8{15,24}     # Freifunk.net
        ];
      }
      function is_valid_network_v6() {
        return net ~ [
          fd00::/8{44,64} # ULA address space as per RFC 4193
        ];
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv4 {
          import none;
          export filter {
            if net = 0.0.0.0/0 then reject;
            accept;
          };
        };
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv6 {
          import none;
          export filter {
            if net = ::/0 then reject;
            accept;
          };
        };
      }
      protocol static {
        route 44.31.42.0/24 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        ipv6 {
          import all;
          export all;
        };
      }
      protocol bgp RR {
        local as 4242421888;
        neighbor range 100.64.88.0/24 as 133846;
        interface eg_net;
        passive on;
        rr client;
        ipv4 {
          import where is_valid_network() || net ~ [100.64.88.0/24, 172.22.68.0/28, 44.31.42.0/24];
          export where is_valid_network() || net ~ [100.64.88.0/24, 172.22.68.0/28, 44.31.42.0/24];
        };
        ipv6 {
          import where is_valid_network_v6() || net ~ 2602:feda:1bf::/48;
          export where is_valid_network_v6() || net ~ 2602:feda:1bf::/48;
        };
      }
      template bgp dnpeers {
        local as 4242421888;
        graceful restart on;
        ipv4 {
          extended next hop;
          import where is_valid_network();
          export where is_valid_network();
        };
        ipv6 {
          import where is_valid_network_v6();
          export where is_valid_network_v6();
        };
      }
    '';
  };
}
