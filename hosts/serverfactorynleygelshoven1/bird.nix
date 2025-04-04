{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    ospf6 = "where net = 2602:fab0:30::/48";
  };
  kernelConf = import profiles.bird.kernel {
    #    src4 = "23.146.88.7";
    src6 = "2602:fab0:30::";
  };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol static {
        route 23.146.88.0/24 blackhole;
        ipv4 {
          import filter {
            bgp_path.prepend(30114);
            bgp_community.add((65009, 174));
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 528));
            bgp_large_community.add((30114, 4, 37));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:30::/44 blackhole;
        route 2602:fab0:30::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 528));
            bgp_large_community.add((30114, 4, 37));
            accept;
          };
          export all;
        };
      }

      template bgp tmpl_upstream {
        local as 30114;
        graceful restart on;
        ipv4 {
          import filter {
            bgp_large_community.add((30114, 1, 2));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 528));
            bgp_large_community.add((30114, 4, 37));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 2));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 528));
            bgp_large_community.add((30114, 4, 37));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }

      protocol bgp AS206075v4 from tmpl_upstream {
        neighbor 192.168.112.2 as 206075;
        password "3mVCWwijLn";
        disabled;
      };
      protocol bgp AS206075v6 from tmpl_upstream {
        neighbor fd74:e849:e9bc:ee83::14 as 206075;
        password "8siTp5qsLE";
        disabled;
      };

    '';
  };
}

