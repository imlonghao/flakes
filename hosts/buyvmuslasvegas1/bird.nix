{ profiles, ... }:
let
  generalConf = import profiles.bird.general;
  dn42Conf = import profiles.bird.dn42;
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      define DN42_REGION = 44;
      define DN42_COUNTRY = 1840;
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv4 {
          import none;
          export filter {
            if net = 0.0.0.0/0 then reject;
            if is_valid_network() then krt_prefsrc = 172.22.68.5;
            accept;
          };
        };
      }
      protocol kernel {
        scan time 10;
        graceful restart on;
        ipv6 {
          import none;
          export filter {
            if net = ::/0 then reject;
            if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:5::;
            accept;
          };
        };
      }
      protocol static {
        route 44.31.42.0/24 blackhole;
        route 172.22.68.0/28 blackhole;
        route 172.22.68.5/32 blackhole;
        ipv4 {
          import all;
          export all;
        };
      }
      protocol static {
        route fd21:5c0c:9b7e:5::/64 blackhole;
        ipv6 {
          import all;
          export all;
        };
      }
      protocol bgp AS53667v4 {
        local as 133846;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv4 {
          import none;
          export filter {
            if net = 44.31.42.0/24 then {
              bgp_path.prepend(133846);
              bgp_path.prepend(133846);
              bgp_large_community.add((53667, 109, 6939));
              accept;
            }
          };
        };
      }
      protocol bgp AS4201271111 from dnpeers {
        neighbor fe80::aa:1111:21 % 'wg31111' as 4201271111;
      }
      protocol bgp AS4242420253 from dnpeers {
        neighbor fe80::0253 % 'wg0253' as 4242420253;
      }
      protocol bgp AS4242420549 from dnpeers {
        neighbor fe80::549:8401:0:1 % 'wg0549' as 4242420549;
      }
      protocol bgp AS4242420826 from dnpeers {
        neighbor fe80::a0e:fb02 % 'wg0826' as 4242420826;
      }
      protocol bgp AS4242420864 from dnpeers {
        neighbor fe80::864:2 % 'wg0864' as 4242420864;
      }
      protocol bgp AS4242420927 from dnpeers {
        neighbor fe80::927 % 'wg0927' as 4242420927;
      }
      protocol bgp AS4242421123 from dnpeers {
        neighbor fe80::1123 % 'wg1123' as 4242421123;
      }
      protocol bgp AS4242421817 from dnpeers {
        neighbor fe80::1817 % 'wg1817' as 4242421817;
      }
      protocol bgp AS4242421877 from dnpeers {
        neighbor fe80::1d90 % 'wg1877' as 4242421877;
      }
      protocol bgp AS4242422032 from dnpeers {
        neighbor fe80::2032 % 'wg2032' as 4242422032;
      }
      protocol bgp AS4242422189 from dnpeers {
        neighbor fe80::2189:ef % 'wg2189' as 4242422189;
      }
      protocol bgp AS4242422464 from dnpeers {
        neighbor fe80::2464 % 'wg2464' as 4242422464;
      }
      protocol bgp AS4242422688 from dnpeers {
        neighbor fe80::2688 % 'wg2688' as 4242422688;
      }
      protocol bgp AS4242422980 from dnpeers {
        neighbor fe80::2980 % 'wg2980' as 4242422980;
      }
      protocol bgp AS4242423021 from dnpeers {
        neighbor fe80::947e % 'wg3021' as 4242423021;
      }
      protocol bgp AS4242423088 from dnpeers {
        neighbor fe80::3088:193 % 'wg3088' as 4242423088;
      }
      protocol bgp AS4242423308 from dnpeers {
        neighbor fe80::3308:65 % 'wg3308' as 4242423308;
      }
      protocol bgp AS4242423868 from dnpeers {
        neighbor fe80::3868 % 'wg3868' as 4242423868;
      }
      protocol bgp AS4242423918 from dnpeers {
        neighbor fe80::3918 % 'wg3918' as 4242423918;
      }
    '';
  };
}
