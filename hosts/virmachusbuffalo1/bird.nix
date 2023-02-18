{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.1/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:1::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 42; country = 1840; ip = 1; config = config; lib = lib; };
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
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
