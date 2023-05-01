{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
  };
  kernelConf = import profiles.bird.kernel { };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:21::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((199632, 1, 1));
            bgp_large_community.add((199632, 2, 1));
            bgp_large_community.add((199632, 3, 442));
            accept;
          };
          export all;
        };
      }
      protocol bgp AS53667 {
        local as 199632;
        neighbor 2605:6400:ffff::2 as 53667;
        multihop 2;
        password "LmBlV4bp";
        ipv6 {
          import none;
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_community.add((174, 970));
              bgp_community.add((174, 960));
              bgp_community.add((174, 950));
              bgp_community.add((174, 940));
              bgp_community.add((174, 930));
              bgp_large_community.add((53667, 101, 6939));
              accept;
            }
            if bgp_large_community ~ [(199632, 1, 1), (199632, 1, 5)] then accept;
          };
        };
      };
    '';
  };
}
