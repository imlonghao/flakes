{ ... }:
{
  # Bird
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.26;
      define DN42_REGION = 42;
      define DN42_COUNTRY = 1840;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.1;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:1::;
            accept;
          };
        };
      }
      protocol static {
        route 172.22.68.0/28 blackhole;
        route 172.22.68.1/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:1::/64 blackhole;
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
            if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
            if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
            accept;
          };
          export filter {
            if !is_valid_network() then {
              reject;
            }
            if source = RTS_STATIC then {
              bgp_community.add((64511, DN42_REGION));
              bgp_community.add((64511, DN42_COUNTRY));
            }
            accept; 
          };
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
            if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
            if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
            accept;
          };
          export filter {
            if !is_valid_network_v6() then {
              reject;
            }
            if source = RTS_STATIC then {
              bgp_community.add((64511, DN42_REGION));
              bgp_community.add((64511, DN42_COUNTRY));
            }
            accept; 
          };
        };
      }
      protocol bgp AS4201271111 from dnpeers {
        neighbor fe80::aa:1111:33 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420247 from dnpeers {
        neighbor fe80::247 % 'wg0247' as 4242420247;
      }
      protocol bgp AS4242420262 from dnpeers {
        neighbor fe80::1234 % 'wg0262' as 4242420262;
      }
      protocol bgp AS4242420591 from dnpeers {
        neighbor fe80::0591 % 'wg0591' as 4242420591;
      }
      protocol bgp AS4242421080 from dnpeers {
        neighbor fe80::123 % 'wg1080' as 4242421080;
      }
      protocol bgp AS4242421816 from dnpeers {
        neighbor fe80::1816 % 'wg1816' as 4242421816;
      }
      protocol bgp AS4242422464 from dnpeers {
        neighbor fe80::2464 % 'wg2464' as 4242422464;
      }
      protocol bgp AS4242422547 from dnpeers {
        neighbor fe80::2547 % 'wg2547' as 4242422547;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:194 % 'wg3088' as 4242423088;
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
