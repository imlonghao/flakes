{
  config,
  self,
  lib,
  ...
}:
let
  generalConf = import "${self}/profiles/bird/general.nix" {
    config = config;
    route4 = ''
      route 172.22.68.0/27 blackhole;
      route 172.22.68.12/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:12::/64 blackhole;
      route 2602:fab0:24:ffff::/64 via 2602:feda:1bf:deaf::19;
    '';
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" {
    src6 = "2602:fab0:24::1";
    dn42 = 12;
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 52;
    country = 1158;
    ip = 12;
    config = config;
    lib = lib;
  };
in
{
  services.bird = {
    enable = true;
    config =
      generalConf
      + dn42Conf
      + kernelConf
      + import "${self}/profiles/bird/blackbgp.nix" { }
      + ''
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
