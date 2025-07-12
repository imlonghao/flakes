{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route6 = ''
      route 2602:feda:1bf::/48 blackhole;
      route 2602:fab0:11::/48 blackhole;
    '';
  };
  kernelConf = import profiles.bird.kernel { };
in
{
  services.bird = {
    enable = true;
    config =
      generalConf
      + kernelConf
      + ''
        protocol bgp AS3204v4 {
          local as 133846;
          neighbor 45.139.193.4 as 3204;
          password "shdyjr#!x0a";
          ipv4 {
            import none;
            export none;
          };
        }
        protocol bgp AS3204v6 {
          local as 133846;
          neighbor 2604:a840:2::4 as 3204;
          password "shdyjr#!x0a";
          ipv6 {
            import none;
            export where net ~ [2602:feda:1bf::/48, 2602:fab0:11::/48];
          };
        }
      '';
  };
}
