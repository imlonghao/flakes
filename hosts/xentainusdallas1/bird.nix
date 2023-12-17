{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    ospf6 = "where net = 2602:fab0:40::/48 || net = 2602:fab0:41::/48";
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
            bgp_path.prepend(199632);
            bgp_path.prepend(199632);
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
        route 2602:fab0:41::/48 via 2602:feda:1bf:deaf::39;
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
      protocol static {
        route 2602:fa11:40::1/128 via "ens3";
        ipv6;
      }
      template bgp tmpl_upstream {
        local as 199632;
        graceful restart on;
        ipv4 {
          import none;
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 3));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
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
        ipv6 {
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(199632);
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
      };

      protocol bgp internalpve1 {
        neighbor 2602:feda:1bf:deaf::39 as 199632;
        local as 199632;
        graceful restart on;
        ipv6 {
          import none;
          export where bgp_large_community ~ [(199632, 3, 840)];
          next hop self;
        };
      };

    '';
  };
}
