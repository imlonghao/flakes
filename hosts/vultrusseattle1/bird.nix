{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
  };
  kernelConf = import profiles.bird.kernel {
    src6 = "2602:fab0:25::";
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
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:25::/48 blackhole;
        ipv6 {
          import filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(199632);
            }
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
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
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 2));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            accept;
          };
          export where bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)];
        };
      }

      protocol bgp vultrv4 from tmpl_upstream {
        neighbor 169.254.169.254 as 64515;
        source address 137.220.42.181;
        password "a7782267";
        multihop 2;
      };
      protocol bgp vultrv6 from tmpl_upstream {
        neighbor 2001:19f0:ffff::1 as 64515;
        source address 2001:19f0:8001:1eb:5400:04ff:fe57:26c3;
        password "a7782267";
        multihop 2;
      };

    '';
  };
}
