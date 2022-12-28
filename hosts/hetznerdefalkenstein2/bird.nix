{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.4/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:4::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 41; country = 1276; ip = 4; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS64719 from dnpeers {
        neighbor fe80::acab % 'wg64719' as 64719;
      }
      protocol bgp AS4242420197 from dnpeers {
        neighbor fe80::42:42:1 % 'wg0197' as 4242420197;
      }
      protocol bgp AS4242420289 from dnpeers {
        neighbor fe80::0289 % 'wg0289' as 4242420289;
      }
      protocol bgp AS4242420385v4 from dnpeers {
        neighbor 172.23.32.36 as 4242420385;
      }
      protocol bgp AS4242420385v6 from dnpeers {
        neighbor fe80::a52b:1888 % 'wg0385' as 4242420385;
      }
      protocol bgp AS4242420499 from dnpeers {
        neighbor fe80::499:1 % 'wg0499' as 4242420499;
      }
      protocol bgp AS4242421588 from dnpeers {
        neighbor fe80::1588 % 'wg1588' as 4242421588;
      }
      protocol bgp AS4242421592 from dnpeers {
        neighbor fe80::1592 % 'wg1592' as 4242421592;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:195 % 'wg3088' as 4242423088;
      }
      protocol bgp AS4242423914 from dnpeers {
        neighbor fe80::ade0 % 'wg3914' as 4242423914;
      }
    '';
  };
}
