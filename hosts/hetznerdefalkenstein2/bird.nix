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
      protocol bgp AS4201271111 from dnpeers {
        neighbor fe80::aa:1111:41 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420197 from dnpeers {
        neighbor fe80::42:42:1 % 'wg0197' as 4242420197;
      }
      protocol bgp AS4242420289 from dnpeers {
        neighbor fe80::0289 % 'wg0289' as 4242420289;
      }
      protocol bgp AS4242420361 from dnpeers {
        neighbor fe80::0361 % 'wg0361' as 4242420361;
      }
      protocol bgp AS4242420385v4 from dnpeers {
        neighbor 172.23.32.36 as 4242420385;
      }
      protocol bgp AS4242420385v6 from dnpeers {
        neighbor fe80::a52b:1888 % 'wg0385' as 4242420385;
      }
      protocol bgp AS4242420458 from dnpeers {
        neighbor fe80::0458 % 'wg0458' as 4242420458;
      }
      protocol bgp AS4242420499 from dnpeers {
        neighbor fe80::499:1 % 'wg0499' as 4242420499;
      }
      protocol bgp AS4242420864 from dnpeers {
        neighbor fe80::864:3 % 'wg0864' as 4242420864;
      }
      protocol bgp AS4242421080 from dnpeers {
        neighbor fe80::117 % 'wg1080' as 4242421080;
      }
      protocol bgp AS4242421513 from dnpeers {
        neighbor fe80::1513 % 'wg1513' as 4242421513;
      }
      protocol bgp AS4242421588 from dnpeers {
        neighbor fe80::1588 % 'wg1588' as 4242421588;
      }
      protocol bgp AS4242421592 from dnpeers {
        neighbor fe80::1592 % 'wg1592' as 4242421592;
      }
      protocol bgp AS4242421817 from dnpeers {
        neighbor fe80::42:1817:a % 'wg1817' as 4242421817;
      }
      protocol bgp AS4242422189 from dnpeers {
        neighbor fe80::2189:e9 % 'wg2189' as 4242422189;
      }
      protocol bgp AS4242422331 from dnpeers {
        neighbor fe80::2331 % 'wg2331' as 4242422331;
      }
      protocol bgp AS4242422458 from dnpeers {
        neighbor fe80::2458 % 'wg2458' as 4242422458;
      }
      protocol bgp AS4242422717 from dnpeers {
        neighbor fe80::2717 % 'wg2717' as 4242422717;
      }
      protocol bgp AS4242422837 from dnpeers {
        neighbor fe80::2837 % 'wg2837' as 4242422837;
      }
      protocol bgp AS4242422923 from dnpeers {
        neighbor fe80::2923 % 'wg2923' as 4242422923;
      }
      protocol bgp AS4242422980 from dnpeers {
        neighbor fe80::2980 % 'wg2980' as 4242422980;
      }
      protocol bgp AS4242423044 from dnpeers {
        neighbor fe80::3044 % 'wg3044' as 4242423044;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:195 % 'wg3088' as 4242423088;
      }
      protocol bgp AS4242423396 from dnpeers {
        neighbor fe80::3396 % 'wg3396' as 4242423396;
      }
      protocol bgp AS4242423847 from dnpeers {
        neighbor fe80::42:3847:42:1888 % 'wg3847' as 4242423847;
      }
      protocol bgp AS4242423868 from dnpeers {
        neighbor fe80::3868 % 'wg3868' as 4242423868;
      }
      protocol bgp AS4242423914 from dnpeers {
        neighbor fe80::ade0 % 'wg3914' as 4242423914;
      }
    '';
  };
}
