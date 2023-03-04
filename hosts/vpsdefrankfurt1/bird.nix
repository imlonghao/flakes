{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route6 = ''
      route 2602:fab0:20::/48 blackhole;
      route 2602:fab0:22::/48 blackhole;
    '';
  };
  kernelConf = import profiles.bird.kernel {
    src6 = "2602:fab0:22::";
  };
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -6Ab -l AS134993 -R 48 APNIC::AS-ILEMONRAIN
      AS134993 = [
          2406:840:fd00::/43{43,48},
          2602:feda:d10::/44{44,48}
      ];

      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv6 {
          import all;
          export where net ~ [2602:fab0:20::/48, 2602:fab0:22::/48];
        };
      }
      protocol bgp AS112 from tmpl_upstream {
        neighbor 2001:7f8:f2:e1::112 as 112;
      };
      protocol bgp AS3204 from tmpl_upstream {
        neighbor 2a09:0:9::9 as 3204;
        multihop 2;
        password "aku236991uha";
      };
      protocol bgp AS134993 {
        neighbor 2001:7f8:f2:e1:0:1349:93:1 as 134993;
        description "iLemonrain Network";
        local as 199632;
        graceful restart on;
        ipv6 {
          import where net ~ AS134993;
          export where net ~ [2602:fab0:20::/48, 2602:fab0:22::/48];
        };
      };
      protocol bgp AS202409rs01 from tmpl_upstream {
        neighbor 2001:7f8:f2:e1::babe:1 as 202409;
      };
      protocol bgp AS202409rs02 from tmpl_upstream {
        neighbor 2001:7f8:f2:e1::dead:1 as 202409;
      };
      protocol bgp AS202409rs03 from tmpl_upstream {
        neighbor 2001:7f8:f2:e1::be5a as 202409;
      };
    '';
  };
}
