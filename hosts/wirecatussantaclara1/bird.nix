{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general { config = config; };
  kernelConf = import profiles.bird.kernel { src6 = "2602:fab0:23::"; };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + import profiles.bird.blackbgp { } + ''
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:23::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 2));
            bgp_large_community.add((30114, 3, 840));
            accept;
          };
          export all;
        };
      }

      template bgp tmpl_upstream {
        local as 30114;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 2));
            bgp_large_community.add((30114, 2, 2));
            bgp_large_community.add((30114, 3, 840));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }

      protocol bgp AS399888 from tmpl_upstream {
        neighbor 2602:fc52:30d::1 as 399888;
        multihop 2;
        source address 2602:fc52:10e:e384::2;
        ipv6 {
          import none;
        };
      };

    '';
  };
}
