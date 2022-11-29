{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.62;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.2;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:2::;
            accept;
          };
        };
      }
      protocol static {
        route 172.22.68.0/28 blackhole;
        route 172.22.68.2/32 blackhole;
        route 172.22.68.8/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e::/64 blackhole;
        route fd21:5c0c:9b7e::8/128 blackhole;
        route fd21:5c0c:9b7e:2::/64 blackhole;
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
          import table;
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
          import table;
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
        neighbor fe80::aa:1111:11 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420253 from dnpeers {
        neighbor fe80::0253 % 'wg0253' as 4242420253;
      }
      protocol bgp AS4242420604 from dnpeers {
        neighbor fe80::0604 % 'wg0604' as 4242420604;
      }
      protocol bgp AS4242420831 from dnpeers {
        neighbor fe80::0831 % 'wg0831' as 4242420831;
      }
      protocol bgp AS4242421588 from dnpeers {
        neighbor fe80::1588 % 'wg1588' as 4242421588;
      }
      protocol bgp AS4242422225v4 from dnpeers {
        neighbor 172.20.12.197 as 4242422225;
      }
      protocol bgp AS4242422225v6 from dnpeers {
        neighbor fe80::2225 % 'wg2225' as 4242422225;
      }
      protocol bgp AS4242422237 from dnpeers {
        neighbor fe80::42:2237 % 'wg2237' as 4242422237;
      }
      protocol bgp AS4242422330 from dnpeers {
        neighbor fe80::2330:5 % 'wg2330' as 4242422330;
      }
      protocol bgp AS4242422331 from dnpeers {
        neighbor fe80::2331 % 'wg2331' as 4242422331;
      }
      protocol bgp AS4242422633 from dnpeers {
        neighbor fe80::2633 % 'wg2633' as 4242422633;
      }
      protocol bgp AS4242422717 from dnpeers {
        neighbor fe80::2717 % 'wg2717' as 4242422717;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:198 % 'wg3088' as 4242423088;
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
