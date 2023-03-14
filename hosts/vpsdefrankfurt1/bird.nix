{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
  };
  kernelConf = import profiles.bird.kernel {
    src6 = "2602:fab0:22::";
  };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:22::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 276));
            accept;
          };
          export all;
        };
      }

      # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -6b -l "define 'APNIC::AS-ILEMONRAIN'" -R 48 APNIC::AS-ILEMONRAIN
      define 'APNIC::AS-ILEMONRAIN' = [
        2406:840:fd00::/43{43,48},
        2602:feda:d10::/44{44,48}
      ];
      # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -6b -l "define 'RIPE::AS199656'" -R 48 AS199656
      define 'RIPE::AS199656' = [
        2a12:dd47:8ed0::/44{44,48},
        2a12:dd47:f700::/40{40,48}
      ];

      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 276));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }
      template bgp tmpl_rs {
        local as 199632;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 4));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 276));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }
      template bgp tmpl_peer {
        local as 199632;
        graceful restart on;
        ipv6 {
          import none;
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }
      template bgp tmpl_downstream {
        local as 199632;
        graceful restart on;
        ipv6 {
          import none;
          export where net.len <= 48 && !is_martian_v6() && bgp_large_community ~ [(199632, 1, *)];
        };
      }

      protocol bgp AS3204 from tmpl_upstream {
        neighbor 2a09:0:9::9 as 3204;
        multihop 2;
        password "aku236991uha";
      };
      protocol bgp AS6939 from tmpl_upstream {
        neighbor 2001:7f8:f2:e1::6939:1 as 6939;
        ipv6 {
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(199632);
              bgp_path.prepend(199632);
              accept;
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
      };
      protocol bgp AS134993 from tmpl_peer {
        neighbor 2001:7f8:f2:e1:0:1349:93:1 as 134993;
        description "iLemonrain Network";
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 3));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 276));
            if net ~ 'APNIC::AS-ILEMONRAIN' then accept;
          };
        };
      };
      protocol bgp AS199656 from tmpl_peer {
        neighbor 2001:7f8:f2:e1:1996:56:0:1 as 199656;
        description "ZYC Network LLC";
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 3));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 276));
            if net ~ 'RIPE::AS199656' then accept;
          };
        };
      };
      protocol bgp AS202409rs01 from tmpl_rs {
        neighbor 2001:7f8:f2:e1::babe:1 as 202409;
      };
      protocol bgp AS202409rs02 from tmpl_rs {
        neighbor 2001:7f8:f2:e1::dead:1 as 202409;
      };
      protocol bgp AS202409rs03 from tmpl_rs {
        neighbor 2001:7f8:f2:e1::be5a as 202409;
      };
      protocol bgp AS212232 from tmpl_downstream {
        neighbor 2a0c:2f07:9459::b11 as 212232;
        description "bgp.tools";
        source address 2602:fab0:22::;
        multihop;
        ipv6 {
          add paths tx;
        };
      };
    '';
  };
}
