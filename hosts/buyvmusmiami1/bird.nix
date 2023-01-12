{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.70;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.6;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:6::;
            accept;
          };
        };
      }
      protocol static {
        route 44.31.42.0/24 blackhole;
        route 172.22.68.0/28 blackhole;
        route 172.22.68.6/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route 2602:fafd:f10::/48 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol bgp AS53667v4 {
        local as 133846;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "r7OUFI1l";
        ipv4 {
          import filter {
            gw = 45.61.188.1;
            accept;
          };
          export filter {
            if net = 44.31.42.0/24 then {
              bgp_path.prepend(133846);
              bgp_path.prepend(133846);
              accept;
            }
          };
        };
      }
      protocol bgp AS53667v6 {
        local as 133846;
        neighbor 2605:6400:ffff::2 as 53667;
        multihop 2;
        password "r7OUFI1l";
        ipv6 {
          import filter {
            accept;
          };
          export filter {
            if net = 2602:fafd:f10::/48 then {
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
    '';
  };
}
