{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.10;
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
        route 172.22.68.0/28 blackhole;
        route 172.22.68.3/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:3::/64 blackhole;
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
        neighbor fe80::aa:1111:1 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420341 from dnpeers {
        neighbor fe80::0341 % 'wg0341' as 4242420341;
      }
      protocol bgp AS4242420549 from dnpeers {
        neighbor fe80::549:3441:0:1 % 'wg0549' as 4242420549;
      }
      protocol bgp AS4242420603v4 from dnpeers {
        neighbor 172.23.7.65 as 4242420603;
      }
      protocol bgp AS4242420603v6 from dnpeers {
        neighbor fe80::0603 % 'wg0603' as 4242420603;
      }
      protocol bgp AS4242420831 from dnpeers {
        neighbor fe80::0831 % 'wg0831' as 4242420831;
      }
      protocol bgp AS4242421588 from dnpeers {
        neighbor fe80::1588 % 'wg1588' as 4242421588;
      }
      protocol bgp AS4242421817 from dnpeers {
        neighbor fe80::42:1817:1 % 'wg1817' as 4242421817;
      }
      protocol bgp AS4242422025 from dnpeers {
        neighbor fe80::2025 % 'wg2025' as 4242422025;
      }
      protocol bgp AS4242422189 from dnpeers {
        neighbor fe80::2189:ee % 'wg2189' as 4242422189;
      }
      protocol bgp AS4242422464 from dnpeers {
        neighbor fe80::2464 % 'wg2464' as 4242422464;
      }
      protocol bgp AS4242422526 from dnpeers {
        neighbor fe80::2526 % 'wg2526' as 4242422526;
      }
      protocol bgp AS4242422717 from dnpeers {
        neighbor fe80::104:50:2030 % 'wg2717' as 4242422717;
      }
      protocol bgp AS4242422923 from dnpeers {
        neighbor fe80::2925 % 'wg2923' as 4242422923;
      }
      protocol bgp AS4242422980 from dnpeers {
        neighbor fe80::2980 % 'wg2980' as 4242422980;
      }
      protocol bgp AS4242423299 from dnpeers {
        neighbor fe80::3:3299 % 'wg3299' as 4242423299;
      }
      protocol bgp AS4242423618 from dnpeers {
        neighbor fe80::3618 % 'wg3618' as 4242423618;
      }
      protocol bgp AS4242423632 from dnpeers {
        neighbor fe80::3632 % 'wg3632' as 4242423632;
      }
      protocol bgp AS4242423704 from dnpeers {
        neighbor fe80::3704 % 'wg3704' as 4242423704;
      }
      protocol bgp AS4242423914 from dnpeers {
        neighbor fe80::ade0 % 'wg3914' as 4242423914;
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
