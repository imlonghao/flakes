{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route6 = ''
      route 2602:fab0:20::/48 blackhole;
      route 2602:fab0:21::/48 blackhole;
    '';
  };
  kernelConf = import profiles.bird.kernel { };
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol bgp AS53667 {
        local as 199632;
        neighbor 2605:6400:ffff::2 as 53667;
        multihop 2;
        password "LmBlV4bp";
        ipv6 {
          import none;
          export where net ~ [2602:fab0:20::/48, 2602:fab0:21::/48];
        };
      };
    '';
  };
}
