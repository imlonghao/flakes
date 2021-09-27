{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.66;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.5;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:5::;
            accept;
          };
        };
      }
      protocol static {
        route 44.31.42.0/24 blackhole;
        route 172.22.68.0/28 blackhole;
        route 172.22.68.5/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:5::/64 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol babel gravity {
        ipv4 {
          import all;
          export where net ~ 100.64.88.0/24 || net = 172.22.68.5/32;
        };
        ipv6 {
          import all;
          export where net ~ 2602:feda:1bf::/48;
        };
        randomize router id;
        interface "gravity";
      }
      protocol bgp AS53667v4 {
        local as 133846;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv4 {
          import filter {
            gw = 199.19.224.1;
            accept;
          };
          export filter {
            if net = 44.31.42.0/24 then {
              bgp_path.prepend(133846);
              bgp_path.prepend(133846);
              bgp_large_community.add((53667, 109, 6939));
              accept;
            }
          };
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
      protocol bgp AS4242420588 from dnpeers {
        neighbor fe80::68:1 % 'wg0588' as 4242420588;
      }
      protocol bgp AS4242420826 from dnpeers {
        neighbor fe80::a0e:fb02 % 'wg0826' as 4242420826;
      }
      protocol bgp AS4242421123 from dnpeers {
        neighbor fe80::1123 % 'wg1123' as 4242421123;
      }
      protocol bgp AS4242422464 from dnpeers {
        neighbor fe80::2464 % 'wg2464' as 4242422464;
      }
      protocol bgp AS4242422980 from dnpeers {
        neighbor fe80::2980 % 'wg2980' as 4242422980;
      }
      protocol bgp ROUTE_COLLECTOR {
        local as 4242421888;
        neighbor fd42:4242:2601:ac12::1 as 4242422602;
        multihop;
        ipv4 {
          add paths tx;
          import none;
          export filter {
            if ( is_valid_network() && source ~ [ RTS_STATIC, RTS_BGP ] )
            then {
              accept;
            }
            reject;
          };
        };
        ipv6 {
          add paths tx;
          import none;
          export filter {
            if ( is_valid_network_v6() && source ~ [ RTS_STATIC, RTS_BGP ] )
            then {
              accept;
            }
            reject;
          };
        };
      }
    '';
  };
}
