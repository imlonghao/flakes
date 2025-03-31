{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    ospf6 = "where net = 2602:fab0:40::/48 || net = 2602:fab0:41::/48";
  };
  kernelConf = import profiles.bird.kernel {
    src4 = "5.56.24.146";
    src6 = "2602:fab0:40::";
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
            bgp_path.prepend(30114);
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 2));
            bgp_large_community.add((30114, 3, 840));
            bgp_large_community.add((30114, 4, 40));
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
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 2));
            bgp_large_community.add((30114, 3, 840));
            bgp_large_community.add((30114, 4, 40));
            accept;
          };
          export all;
        };
      }
      protocol static {
        ipv6;
        route ::/0 blackhole;
        route 2602:fa11:40::1/128 via "ens3";
        route 2602:fa11:40::6/128 via "ens3";
      }
      template bgp tmpl_upstream {
        local as 30114;
        graceful restart on;
        ipv4 {
          import none;
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
        ipv6 {
          import none;
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }

      protocol bgp AS15353v4 from tmpl_upstream {
        neighbor 5.56.24.4 as 15353;
        password "8wqY5P6H";
      };
      protocol bgp AS15353v6 from tmpl_upstream {
        neighbor 2602:f71e:41:4:: as 15353;
        source address 2602:f71e:41:6f::a;
        password "8wqY5P6H";
        multihop 20;
        ipv6 {
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(30114);
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      };

      protocol bgp internalpve1 {
        neighbor fd99:100:64:1::29 as 30114;
        local as 30114;
        graceful restart on;
        ipv6 {
          import all;
          export where net=::/0;
          next hop self;
        };
      };

    '';
  };
}
