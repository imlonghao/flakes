{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
  };
  kernelConf = import profiles.bird.kernel {
    src6 = "2602:fab0:28::";
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
            bgp_community.add((21738, 211));
            bgp_community.add((21738, 349));
            bgp_community.add((21738, 359));
            bgp_community.add((21738, 369));

            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            bgp_large_community.add((199632, 4, 35));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:28::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 2));
            bgp_large_community.add((199632, 3, 840));
            bgp_large_community.add((199632, 4, 35));
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

      protocol bgp AS21738v4 from tmpl_upstream {
        neighbor 23.150.40.66 as 21738;
        source address 23.150.40.72;
      };
      protocol bgp AS21738v6 from tmpl_upstream {
        neighbor 2602:2b7:40:64::66 as 21738;
        source address 2602:02b7:40:64::72;
        ipv6 {
          import none;
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(199632);
              accept;
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
      };

      protocol bgp AS25759v4 from tmpl_upstream {
        neighbor 23.150.40.88 as 25759;
        source address 23.150.40.72;
      };
      protocol bgp AS25759v6 from tmpl_upstream {
        neighbor 2602:2b7:40:64::88 as 25759;
        source address 2602:02b7:40:64::72;
        ipv6 {
          import none;
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(199632);
              accept;
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
      };

    '';
  };
}
