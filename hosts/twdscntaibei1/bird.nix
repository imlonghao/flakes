{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route6 = ''
      route 2602:fab0:24:ffff::/64 via 2602:feda:1bf:deaf::19;
    '';
  };
  kernelConf = import profiles.bird.kernel { src6 = "2602:fab0:24::1"; };
in {
  services.bird = {
    enable = true;
    config = generalConf + kernelConf + import profiles.bird.blackbgp { } + ''
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:24::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 4));
            bgp_large_community.add((30114, 3, 158));
            accept;
          };
          export all;
        };
      }

      template bgp tmpl_upstream {
        local as 30114;
        local role customer;
        graceful restart on;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 2));
            bgp_large_community.add((30114, 2, 4));
            bgp_large_community.add((30114, 3, 158));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }
      template bgp tmpl_rs {
        local as 30114;
        local role rs_client;
        graceful restart on;
        ipv6 {
          import filter {
            if bgp_path.first~[945, 54625, 57481, 61302] then reject;
            bgp_large_community.add((30114, 1, 4));
            bgp_large_community.add((30114, 2, 4));
            bgp_large_community.add((30114, 3, 158));
            accept;
          };
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }
      template bgp tmpl_peer {
        local as 30114;
        local role peer;
        graceful restart on;
        ipv6 {
          import none;
          export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
        };
      }
      template bgp tmpl_downstream {
        local as 30114;
        local role provider;
        graceful restart on;
        ipv6 {
          import none;
          export where net.len <= 48 && !is_martian_v6() && bgp_large_community ~ [(30114, 1, *)];
        };
      }

      protocol bgp AS6939 from tmpl_upstream {
        neighbor 2a0f:5707:ffe3::30 as 6939;
        ipv6 {
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_path.prepend(30114);
              bgp_path.prepend(30114);
              accept;
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      };
      protocol bgp AS13335 from tmpl_peer {
        neighbor 2a0f:5707:ffe3::34 as 13335;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 3));
            bgp_large_community.add((30114, 2, 4));
            bgp_large_community.add((30114, 3, 158));
            accept;
          };
        };
      };
      protocol bgp AS32934s1 from tmpl_peer {
        neighbor 2a0f:5707:ffe3::137 as 32934;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 3));
            bgp_large_community.add((30114, 2, 4));
            bgp_large_community.add((30114, 3, 158));
            accept;
          };
        };
      };
      protocol bgp AS32934s2 from tmpl_peer {
        neighbor 2a0f:5707:ffe3::138 as 32934;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 3));
            bgp_large_community.add((30114, 2, 4));
            bgp_large_community.add((30114, 3, 158));
            accept;
          };
        };
      };
      protocol bgp AS38855rs01 from tmpl_rs {
        neighbor 2a0f:5707:ffe3::1 as 38855;
      };
      protocol bgp AS38855rs02 from tmpl_rs {
        neighbor 2a0f:5707:ffe3::2 as 38855;
      };
      protocol bgp AS199594 from tmpl_rs {
        neighbor fe80::1980:1:1 % 'kskb-ix' as 199594;
        source address fe80::30:114;
      };

    '';
  };
}
