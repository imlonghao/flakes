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
      protocol bgp RR {
        local as 4242421888;
        neighbor internal;
        neighbor fe80::dcad:beff:feef:1;
        interface "eg_net";
        direct;
        ipv4 {
          next hop self;
          import all;
          export all;
        };
        ipv6 {
          next hop self;
          import all;
          export all;
        };
      }
      protocol bgp AS53667v4 {
        local as 133846;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv4 {
          import none;
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
      roa4 table dn42_roa;
      roa6 table dn42_roa_v6;
      protocol rpki rpki_dn42{
        roa4 { table dn42_roa; };
        roa6 { table dn42_roa_v6; };
        remote "103.167.150.135" port 8282;
        retry keep 90;
        refresh keep 900;
        expire keep 172800;
      }
      template bgp dnpeers {
        local as 4242421888;
        graceful restart on;
        ipv4 {
          extended next hop;
          import filter {
            if (roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID) then {
              print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
              reject;
            }
            if !is_valid_network() then {
              reject;
            }
            accept;
          };
          export where is_valid_network();
        };
        ipv6 {
          import filter {
            if (roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID) then {
              print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
              reject;
            }
            if !is_valid_network_v6() then {
              reject;
            }
            accept;
          };
          export where is_valid_network_v6();
        };
      }
      protocol bgp AS4201271111 from dnpeers {
        neighbor fe80::aa:1111:21 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420253 from dnpeers {
        neighbor fe80::0253 % 'wg0253' as 4242420253;
      }
      protocol bgp AS4242420549 from dnpeers {
        neighbor fe80::549:8401:0:1 % 'wg0549' as 4242420549;
      }
      protocol bgp AS4242420826 from dnpeers {
        neighbor fe80::a0e:fb02 % 'wg0826' as 4242420826;
      }
      protocol bgp AS4242421123 from dnpeers {
        neighbor fe80::1123 % 'wg1123' as 4242421123;
      }
      protocol bgp AS4242421586v4 from dnpeers {
        neighbor 172.21.75.32 as 4242421586;
      }
      protocol bgp AS4242421586v6 from dnpeers {
        neighbor fe80::1586 % 'wg1586' as 4242421586;
      }
      protocol bgp AS4242421817 from dnpeers {
        neighbor fe80::1817 % 'wg1817' as 4242421817;
      }
      protocol bgp AS4242421877 from dnpeers {
        neighbor fe80::1d90 % 'wg1877' as 4242421877;
      }
      protocol bgp AS4242422032 from dnpeers {
        neighbor fe80::2032 % 'wg2032' as 4242422032;
      }
      protocol bgp AS4242422189 from dnpeers {
        neighbor fe80::2189:ef % 'wg2189' as 4242422189;
      }
      protocol bgp AS4242422464 from dnpeers {
        neighbor fe80::2464 % 'wg2464' as 4242422464;
      }
      protocol bgp AS4242422688 from dnpeers {
        neighbor fe80::2688 % 'wg2688' as 4242422688;
      }
      protocol bgp AS4242422980 from dnpeers {
        neighbor fe80::2980 % 'wg2980' as 4242422980;
      }
      protocol bgp AS4242423021 from dnpeers {
        neighbor fe80::947e % 'wg3021' as 4242423021;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:193 % 'wg3088' as 4242423088;
      }
      protocol bgp AS4242423308 from dnpeers {
        neighbor fe80::3308:65 % 'wg3308' as 4242423308;
      }
      protocol bgp AS4242423918 from dnpeers {
        neighbor fe80::3918 % 'wg3918' as 4242423918;
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
