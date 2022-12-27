{ config, profiles, ... }:
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
  dn42Conf = import profiles.bird.dn42 { region = 51; country = 1702; ip = 2; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS4201271111 from dnpeers {
        neighbor fe80::aa:1111:11 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420253 from dnpeers {
        neighbor fe80::0253 % 'wg0253' as 4242420253;
      }
      protocol bgp AS4242420458 from dnpeers {
        neighbor fe80::0458 % 'wg0458' as 4242420458;
      }
      protocol bgp AS4242420604 from dnpeers {
        neighbor fe80::0604 % 'wg0604' as 4242420604;
      }
      protocol bgp AS4242420831 from dnpeers {
        neighbor fe80::0831 % 'wg0831' as 4242420831;
      }
      protocol bgp AS4242421080 from dnpeers {
        neighbor fe80::1080:39 % 'wg1080' as 4242421080;
      }
      protocol bgp AS4242421255 from dnpeers {
        neighbor fe80::1020 % 'wg1255' as 4242421255;
      }
      protocol bgp AS4242421588 from dnpeers {
        neighbor fe80::1588 % 'wg1588' as 4242421588;
      }
      protocol bgp AS4242422225v4 from dnpeers {
        neighbor 172.20.12.197 as 4242422225;
      }
      protocol bgp AS4242422225v6 from dnpeers {
        neighbor fe80::2225 % 'wg2225' as 4242422225;
      }
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
