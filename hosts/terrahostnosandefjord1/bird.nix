{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route6 = ''
      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff83::/48 blackhole;
    '';
  };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + ''
      protocol bgp AS56655a {
        neighbor 2a03:94e0:fef0:: as 56655;
        local as 133846;
        graceful restart on;
        multihop 3;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff83::/48;
        };
      }
      protocol bgp AS56655b {
        neighbor 	2a03:94e0:fff0:: as 56655;
        local as 133846;
        graceful restart on;
        multihop 3;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff83::/48;
        };
      }
    '';
  };
}
