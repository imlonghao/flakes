{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.21;
      timeformat protocol iso long;
      protocol direct {
        ipv4;
        ipv6;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.3;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:3::;
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
        route 2602:feda:1bf::/48 blackhole;
        route 2a09:b280:ff80::/48 blackhole;
        ipv6 {
          import all;
          export all;
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

      protocol bgp xtom {
        neighbor 2a03:d9c0:2000::5 as 3204;
        password "ffdsuu3xh1f1f";
        local as 133846;
        graceful restart on;
        ipv6 {
          import none;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }

      protocol bgp rs01v4 {
        neighbor 185.1.155.254 as 202409;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export none;
        };
      }
      protocol bgp rs01v6 {
        neighbor 2a0c:b641:701::a5:20:2409:1 as 202409;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
      protocol bgp rs02v4 {
        neighbor 185.1.155.253 as 202409;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export none;
        };
      }
      protocol bgp rs02v6 {
        neighbor 2a0c:b641:701::a5:20:2409:2 as 202409;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
      protocol bgp AS112v4 {
        neighbor 185.1.155.112 as 112;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export none;
        };
      }
      protocol bgp AS112v6 {
        neighbor 2a0c:b641:701:0:a5:0:112:1 as 112;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
    '';
  };
}
