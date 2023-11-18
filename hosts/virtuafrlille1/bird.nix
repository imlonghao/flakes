{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
  };
  kernelConf = import profiles.bird.kernel {
    src6 = "2602:fab0:27::";
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
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 250));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:27::/48 blackhole;
        route 2602:fab0:30::/44 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 250));
            accept;
          };
          export all;
        };
      }
      protocol static {
        ipv4;
        route 0.0.0.0/0 blackhole;
      }
      protocol static {
        ipv6;
        route ::/0 blackhole;
      }

      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 250));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }


      protocol bgp AS64661v4 from tmpl_upstream {
        neighbor 188.214.24.166 as 64661;
        multihop 2;
        password "LTDSjU4jvMNe";
        source address 185.154.155.64;
        ipv4 {
          import none;
          export filter {
            if net = 23.146.88.0/24 then {
              bgp_community.add((35661,7002));
              bgp_community.add((35661,7024));
              bgp_large_community.add((6695,902,137409));
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
      };
      protocol bgp AS64661v6 from tmpl_upstream {
        neighbor 2a07:8dc1::be:1 as 64661;
        multihop 2;
        password "LTDSjU4jvMNe";
        source address 2a07:8dc1:20:149::1;
        ipv6 {
          import none;
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(199632);
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
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
