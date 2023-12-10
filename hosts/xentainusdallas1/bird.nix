{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    ospf6 = "where net = 2602:fab0:40::/48";
  };
  kernelConf = import profiles.bird.kernel {
    src4 = "23.26.226.82";
    src6 = "2602:fab0:40::";
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
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            bgp_large_community.add((199632, 4, 40));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:40::/44 blackhole;
        route 2602:fab0:40::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            bgp_large_community.add((199632, 4, 40));
            accept;
          };
          export all;
        };
      }

      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv4 {
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            bgp_large_community.add((199632, 4, 40));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            bgp_large_community.add((199632, 4, 40));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }

      protocol bgp AS15353v4 from tmpl_upstream {
        neighbor 23.26.226.1 as 15353;
        password "8wqY5P6H";
      };
      protocol bgp AS15353v6 from tmpl_upstream {
        neighbor 2602:fa11:40::1 as 15353;
        password "8wqY5P6H";
        multihop 2;
      };

    '';
  };
}

