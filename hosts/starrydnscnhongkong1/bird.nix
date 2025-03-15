{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 44.31.42.0/24 blackhole;
    '';
    route6 = ''
      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff81::/48 blackhole;
    '';
  };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + import profiles.bird.kernel { } + ''
      protocol bgp starrydns4 {
        neighbor 103.205.9.1 as 134835;
        source address 103.205.9.90;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export where net = 44.31.42.0/24;
        };
      }
      protocol bgp starrydns6 {
        neighbor 2403:ad80:98:fffa::253 as 134835;
        source address 2403:ad80:98:c60::f6f4;
        multihop 2;
        local as 133846;
        graceful restart on;
        ipv6 {
          import none;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff81::/48;
        };
        multihop;
      }
    '';
  };
}
