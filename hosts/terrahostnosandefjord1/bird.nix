{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.6/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:6::/64 blackhole;

      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff83::/48 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 41; country = 1578; ip = 6; config = config; lib = lib; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
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
