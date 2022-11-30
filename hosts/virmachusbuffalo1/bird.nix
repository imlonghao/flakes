{ config, profiles, ... }:
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
  dn42Conf = import profiles.bird.dn42 { region = 42; country = 1840; ip = 1; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS64719 from dnpeers {
        neighbor fe80::acab % 'wg64719' as 64719;
      }
      protocol bgp AS4201271111 from dnpeers {
        neighbor fe80::aa:1111:33 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420247 from dnpeers {
        neighbor fe80::247 % 'wg0247' as 4242420247;
      }
      protocol bgp AS4242420262 from dnpeers {
        neighbor fe80::1234 % 'wg0262' as 4242420262;
      }
      protocol bgp AS4242420591 from dnpeers {
        neighbor fe80::0591 % 'wg0591' as 4242420591;
      }
      protocol bgp AS4242421080 from dnpeers {
        neighbor fe80::1080:119 % 'wg1080' as 4242421080;
      }
      protocol bgp AS4242421816 from dnpeers {
        neighbor fe80::1816 % 'wg1816' as 4242421816;
      }
      protocol bgp AS4242422464 from dnpeers {
        neighbor fe80::2464 % 'wg2464' as 4242422464;
      }
      protocol bgp AS4242422547 from dnpeers {
        neighbor fe80::2547 % 'wg2547' as 4242422547;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:194 % 'wg3088' as 4242423088;
      }
      protocol bgp AS4242423914 from dnpeers {
        neighbor fe80::ade0 % 'wg3914' as 4242423914;
      }
    '';
  };
}
