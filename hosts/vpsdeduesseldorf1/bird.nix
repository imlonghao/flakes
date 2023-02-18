{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 44.31.42.0/24 blackhole;
    '';
    route6 = ''
      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff80::/48 blackhole;
    '';
  };
  kernelConf = import profiles.bird.kernel;
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol bgp xtom {
        neighbor 2a03:d9c0:2000::5 as 3204;
        password "ffdsuu3xh1f1f";
        local as 133846;
        graceful restart on;
        ipv6 {
          import none;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
      protocol bgp rs01v4 {
        neighbor 185.1.155.254 as 202409;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export none;
        };
      }
      protocol bgp rs01v6 {
        neighbor 2a0c:b641:701::a5:20:2409:1 as 202409;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
      protocol bgp rs02v4 {
        neighbor 185.1.155.253 as 202409;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export none;
        };
      }
      protocol bgp rs02v6 {
        neighbor 2a0c:b641:701::a5:20:2409:2 as 202409;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
      protocol bgp AS112v4 {
        neighbor 185.1.155.112 as 112;
        local as 133846;
        graceful restart on;
        ipv4 {
          import all;
          export none;
        };
      }
      protocol bgp AS112v6 {
        neighbor 2a0c:b641:701:0:a5:0:112:1 as 112;
        local as 133846;
        graceful restart on;
        ipv6 {
          import all;
          export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff80::/48;
        };
      }
      protocol bgp bgptoolsv4 {
        neighbor 185.230.223.54 as 212232;
        local as 133846;
        graceful restart on;
        source address 45.131.153.201;
        multihop;
        ipv4 {
          import all;
          export where net.len <= 24 && !is_martian_v4() && source ~ [ RTS_STATIC, RTS_BGP ];
          add paths tx;
        };
      }
      protocol bgp bgptoolsv6 {
        neighbor 2a0c:2f07:9459::b8 as 212232;
        local as 133846;
        graceful restart on;
        source address 2a03:d9c0:2000::c2;
        multihop;
        ipv6 {
          import all;
          export where net.len <= 48 && !is_martian_v6() && source ~ [ RTS_STATIC, RTS_BGP ];
          add paths tx;
        };
      }
      protocol babel {
        ipv4 {
          import all;
          export where net ~ 100.88.1.0/24 || source = RTS_BABEL;
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
