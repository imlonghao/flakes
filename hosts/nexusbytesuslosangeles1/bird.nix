{ ... }:
{
  services.bird2 = {
    enable = true;
    config = ''
      router id 100.64.88.34;
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
            if is_valid_network() then krt_prefsrc = 172.22.68.9;
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
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:9::;
            accept;
          };
        };
      }
      protocol static {
        route 172.22.68.0/28 blackhole;
        route 172.22.68.9/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:9::/64 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol babel gravity {
        ipv4 {
          import all;
          export where net ~ 100.64.88.0/24 || net = 172.22.68.9/32;
        };
        ipv6 {
          import all;
          export where net ~ 2602:feda:1bf::/48;
        };
        randomize router id;
        interface "gravity";
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
