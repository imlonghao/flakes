{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
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
        route 23.146.88.0/24 blackhole;
        ipv4 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            bgp_large_community.add((30114, 4, 28));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:22::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            bgp_large_community.add((30114, 4, 28));
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
      # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -6b -l "define 'RIPE::AS51019:AS-ALL'" -R 48 AS51019:AS-ALL
      define 'RIPE::AS51019:AS-ALL' = [
        2001:67c:bdc::/48,
        2602:fafd:f05::/48,
        2602:fd50:1020::/44{44,48},
        2602:fd50:10f4::/48,
        2a05:1084::/32{32,48},
        2a05:dfc1:b00f::/48,
        2a05:dfc1:ff00::/40{40,48},
        2a05:dfc5:fffd::/48,
        2a06:1287:4900::/40{40,48},
        2a06:a005:437::/48,
        2a06:a005:1871::/48,
        2a07:54c1:3300::/40{40,48},
        2a07:54c2:1000::/36{36,48},
        2a07:54c2:b00b::/48,
        2a07:54c4:175a::/48,
        2a07:54c4:175c::/48,
        2a07:54c4:175d::/48,
        2a07:54c4:175e::/48,
        2a07:54c6::/32{32,48},
        2a0a:6040:1300::/40{40,48},
        2a0a:6040:3ffd::/48,
        2a0a:6040:9f00::/40{40,48},
        2a12:dd47:84fd::/48
      ];
      # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -6b -l "define 'RIPE::AS199656'" -R 48 AS199656
      define 'RIPE::AS199656' = [
        2a12:dd47:8ed0::/44{44,48},
        2a12:dd47:f700::/40{40,48}
      ];

      template bgp tmpl_upstream {
        local as 30114;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 2));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }
      template bgp tmpl_rs {
        local as 30114;
        graceful restart on;
        ipv4 {
          import filter {
            bgp_large_community.add((30114, 1, 4));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 4));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }
      template bgp tmpl_peer {
        local as 30114;
        graceful restart on;
        ipv6 {
          import none;
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }
      template bgp tmpl_downstream {
        local as 30114;
        graceful restart on;
        ipv6 {
          import none;
          export where net.len <= 48 && !is_martian_v6() && bgp_large_community ~ [(30114, 1, *)];
        };
      }

      protocol bgp AS3204 from tmpl_upstream {
        neighbor 2a09:0:9::9 as 3204;
        multihop 2;
        password "aku236991uha";
        ipv6 {
          export filter {
            bgp_large_community.add((202409, 0, 0));
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(30114);
              bgp_path.prepend(30114);
              accept;
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      };
      protocol bgp AS6939 from tmpl_upstream {
        neighbor 2001:7f8:f2:e1::6939:1 as 6939;
        ipv6 {
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(30114);
              bgp_path.prepend(30114);
              accept;
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      };
      protocol bgp AS51019 from tmpl_peer {
        neighbor 2001:7f8:f2:e1:0:5:1019:1 as 51019;
        description "Kjartan Hrafnkelsson";
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 3));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            if net ~ 'RIPE::AS51019:AS-ALL' then accept;
          };
        };
      };
      protocol bgp AS134993 from tmpl_peer {
        neighbor 2001:7f8:f2:e1:0:1349:93:1 as 134993;
        description "iLemonrain Network";
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 3));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            if net ~ 'APNIC::AS-ILEMONRAIN' then accept;
          };
        };
      };
      protocol bgp AS199656 from tmpl_peer {
        neighbor 2001:7f8:f2:e1:1996:56:0:1 as 199656;
        description "ZYC Network LLC";
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 3));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 276));
            if net ~ 'RIPE::AS199656' then accept;
          };
        };
      };
      protocol bgp AS202409rs01v4 from tmpl_rs {
        neighbor 185.1.166.100 as 202409;
      };
      protocol bgp AS202409rs01v6 from tmpl_rs {
        neighbor 2001:7f8:f2:e1::babe:1 as 202409;
      };
      protocol bgp AS202409rs02v4 from tmpl_rs {
        neighbor 185.1.166.200 as 202409;
      };
      protocol bgp AS202409rs02v6 from tmpl_rs {
        neighbor 2001:7f8:f2:e1::dead:1 as 202409;
      };
      protocol bgp AS202409rs03v4 from tmpl_rs {
        neighbor 185.1.166.254 as 202409;
      };
      protocol bgp AS202409rs03v6 from tmpl_rs {
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
