{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.2/32 blackhole;
      route 172.22.68.8/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e::/64 blackhole;
      route fd21:5c0c:9b7e::8/128 blackhole;
      route fd21:5c0c:9b7e:2::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 51; country = 1702; ip = 2; config = config; lib = lib; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS4242422237 from dnpeers {
        neighbor fe80::42:2237 % 'wg2237' as 4242422237;
      }
      protocol bgp AS4242422330 from dnpeers {
        neighbor fe80::2330:5 % 'wg2330' as 4242422330;
      }
      protocol bgp AS4242422331 from dnpeers {
        neighbor fe80::2331 % 'wg2331' as 4242422331;
      }
      protocol bgp AS4242422633 from dnpeers {
        neighbor fe80::2633 % 'wg2633' as 4242422633;
      }
      protocol bgp AS4242422717 from dnpeers {
        neighbor fe80::2717 % 'wg2717' as 4242422717;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:198 % 'wg3088' as 4242423088;
      }
    '';
  };
}
