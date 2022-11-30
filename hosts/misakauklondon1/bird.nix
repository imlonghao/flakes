{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 44.31.42.0/24 blackhole;
    '';
    route6 = "";
  };
in
{
  services.bird2 = {
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
      protocol bgp RR {
        local as 4242421888;
        neighbor internal;
        neighbor range fe80::/64;
        interface "eg_net";
        rr client;
        direct;
        ipv4 {
          import filter {
            if !(is_valid_network() || net ~ [100.64.88.0/24, 172.22.68.0/28+, 44.31.42.0/24]) then reject;
            bgp_local_pref = 100;
            accept;
          };
          export where is_valid_network() || net ~ [100.64.88.0/24, 172.22.68.0/28+, 44.31.42.0/24];
        };
        ipv6 {
          import filter {
            if !(is_valid_network_v6() || net ~ 2602:feda:1bf::/48) then reject;
            bgp_local_pref = 100;
            accept;
          };
          export where is_valid_network_v6() || net ~ 2602:feda:1bf::/48;
        };
      }
    '';
  };
}
