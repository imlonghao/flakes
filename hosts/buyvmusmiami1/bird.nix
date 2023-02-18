{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 23.146.88.0/24 blackhole;
      route 23.146.88.1/32 blackhole;
      route 23.146.88.248/29 blackhole;
      route 44.31.42.0/24 blackhole;
    '';
    route6 = ''
      route 2602:fab0:10::/48 blackhole;
      route 2602:fafd:f10::/48 blackhole;
    '';
  };
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + ''
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
            if net = 23.146.88.0/24 then accept;
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
            gw = 2605:6400:40::1;
            accept;
          };
          export where net = 2602:fafd:f10::/48 || net = 2602:fab0:10::/48;
        };
      }
      protocol babel {
        ipv4 {
          import all;
          export where net ~ [100.88.1.0/24{24,32}, 23.146.88.0/24{24,32}] || source = RTS_BABEL;
        };
        ipv6 {
          import all;
          export where source = RTS_BABEL;
        };
        interface "vmesh" {
          type tunnel;
        };
      }
    '';
  };
}
