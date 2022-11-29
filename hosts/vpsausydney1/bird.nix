{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.9/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:9::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 53; country = 1036; ip = 9; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS4242420458 from dnpeers {
        neighbor fe80::458 % 'wg0458' as 4242420458;
      }
      protocol bgp AS4242421080 from dnpeers {
        neighbor fe80::1080:125 % 'wg1080' as 4242421080;
      }
      protocol bgp AS4242422633 from dnpeers {
        neighbor fe80::2633 % 'wg2633' as 4242422633;
      }
    '';
  };
}
