{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
  };
  kernelConf = import profiles.bird.kernel { };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol static {
        route 23.146.88.0/24 blackhole;
        ipv4 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 442));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:21::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 1));
            bgp_large_community.add((30114, 3, 442));
            accept;
          };
          export all;
        };
      }
      protocol bgp AS53667v4 {
        local as 30114;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "LmBlV4bp";
        ipv4 {
          import none;
          export filter {
            if net = 23.146.88.0/24 then {
              bgp_large_community.add((53667, 102, 174));
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      }
      protocol bgp AS53667v6 {
        local as 30114;
        neighbor 2605:6400:ffff::2 as 53667;
        multihop 2;
        password "LmBlV4bp";
        ipv6 {
          import none;
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_community.add((174, 140));
              bgp_large_community.add((53667, 102, 174));
              bgp_large_community.add((53667, 101, 6939));
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      };
    '';
  };
}
