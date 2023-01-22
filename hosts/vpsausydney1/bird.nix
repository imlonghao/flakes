{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.9/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:9::/64 blackhole;
      route 2a06:a005:b60::/48 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 53; country = 1036; ip = 9; config = config; lib = lib; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS44570 {
        neighbor 2a06:a004:101d::1 as 44570;
        local as 133846;
        graceful restart on;
        ipv6 {
          import none;
          export where net = 2a06:a005:b60::/48;
        };
      }
    '';
  };
}
