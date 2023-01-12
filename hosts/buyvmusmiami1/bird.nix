{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 44.31.42.0/24 blackhole;
    '';
    route6 = ''
      route 2602:fafd:f10::/48 blackhole;
    '';
  };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + ''
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
    '';
  };
}
