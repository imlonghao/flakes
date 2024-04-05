{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    ospf6 = "where net = 2602:fab0:32::/48";
  };
  kernelConf = import profiles.bird.kernel {
    src4 = "89.23.86.39";
    src6 = "2602:fab0:32::";
  };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      ipv4 table as199632v4;
      ipv6 table as199632v6;
      protocol kernel kern199632v4 {
        ipv4 {
          table as199632v4;
          export all;
        };
        kernel table 199632;
      }
      protocol kernel kern199632v6 {
        ipv6 {
          table as199632v6;
          export filter {
            krt_prefsrc = 2602:fab0:32::;
            accept;
          };
        };
        kernel table 199632;
      }

      protocol static {
        route 23.146.88.0/24 blackhole;
        ipv4 {
          table as199632v4;
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 208));
            bgp_large_community.add((199632, 4, 38));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:30::/44 blackhole;
        route 2602:fab0:32::/48 blackhole;
        ipv6 {
          table as199632v6;
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 208));
            bgp_large_community.add((199632, 4, 38));
            accept;
          };
          export all;
        };
      }

      protocol static {
        ipv4;
        route 0.0.0.0/1 via 10.200.10.1;
        route 128.0.0.0/1 via 10.200.10.1;
      }
      protocol static {
        ipv6;
        route 2000::/3 via fd00:19:96:32::a;
      }

      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv4 {
          table as199632v4;
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 208));
            bgp_large_community.add((199632, 4, 38));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
        ipv6 {
          table as199632v6;
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 208));
            bgp_large_community.add((199632, 4, 38));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }

      template bgp tmpl_rs {
        local as 199632;
        graceful restart on;
        ipv4 {
          table as199632v4;
          import filter {
            bgp_large_community.add((199632, 1, 4));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 208));
            bgp_large_community.add((199632, 4, 38));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
        ipv6 {
          table as199632v6;
          import filter {
            bgp_large_community.add((199632, 1, 4));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 208));
            bgp_large_community.add((199632, 4, 38));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }

      protocol bgp AS199545v4 from tmpl_upstream {
        neighbor 10.200.10.1 as 199545;
        password "iIu4fxPEpwpRK4sG";
      };
      protocol bgp AS199545v6 from tmpl_upstream {
        neighbor fd00:19:96:32::a as 199545;
        password "iIu4fxPEpwpRK4sG";
      };

      protocol bgp NorthIX from tmpl_rs {
        neighbor 2001:67c:bec:c7::111 as 199545;
      };

      protocol bgp internalovh {
        local as 199632;
        graceful restart on;
        neighbor 2602:feda:1bf:deaf::24 as 199632;
        ipv4 {
          import none;
          export where net = 0.0.0.0/0;
          next hop self;
        };
        ipv6 {
          import where net = 2602:fab0:31:1::/64;
          export where net = ::/0;
          next hop self;
        };
      };

    '';
  };
}

