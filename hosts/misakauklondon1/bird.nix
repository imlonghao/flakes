{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 44.31.42.0/24 blackhole;
    '';
    route6 = ''
      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff85::/48 blackhole;
    '';
  };
in {
  services.bird = {
    enable = true;
    config = generalConf + ''
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
        ] && net !~ [10.42.0.0/24];
      }
      function is_valid_network_v6() {
        return net ~ [
          fd00::/8{44,64} # ULA address space as per RFC 4193
        ] && net !~ [fd99:100:64:1::/64];
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
      protocol bgp RR {
        local as 4242421888;
        neighbor internal;
        neighbor range fd99:100:64:1::/64;
        interface "gravity";
        rr client;
        direct;
        ipv4 {
          add paths tx;
          import filter {
            if !(is_valid_network() || net ~ [100.64.88.0/24, 172.22.68.0/27+, 44.31.42.0/24]) then reject;
            bgp_local_pref = 100;
            accept;
          };
          export where is_valid_network() || net ~ [100.64.88.0/24, 172.22.68.0/27+, 44.31.42.0/24];
        };
        ipv6 {
          add paths tx;
          import filter {
            if !(is_valid_network_v6() || net ~ 2602:feda:1bf::/48) then reject;
            bgp_local_pref = 100;
            accept;
          };
          export where is_valid_network_v6() || net ~ 2602:feda:1bf::/48;
        };
      }
      protocol bgp AS57695 {
        local as 133846;
        neighbor 2a0b:4342:ffff:: as 57695;
        multihop 2;
        source address 2a0f:3b03:101:12:5054:ff:fe16:e83c;
        ipv6 {
          import none;
          export where net ~ [2602:feda:1bf::/48, 2a09:b280:ff85::/48];
        };
      }
    '';
  };
}
