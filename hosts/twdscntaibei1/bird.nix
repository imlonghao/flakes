{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
  };
  kernelConf = import profiles.bird.kernel {
    src6 = "2602:fab0:24::";
  };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:24::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 4));
            bgp_large_community.add((199632, 3, 158));
            accept;
          };
          export all;
        };
      }

      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 4));
            bgp_large_community.add((199632, 3, 158));
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
            bgp_large_community.add((199632, 2, 4));
            bgp_large_community.add((199632, 3, 158));
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

      protocol bgp AS38855rs01 from tmpl_rs {
        neighbor 2a0f:5707:ffe3::1 as 38855;
      };
      protocol bgp AS38855rs02 from tmpl_rs {
        neighbor 2a0f:5707:ffe3::2 as 38855;
      };

    '';
  };
}
