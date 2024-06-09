{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = "";
    route6 = ''
      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff84::/48 blackhole;
    '';
  };
  kernelConf = import profiles.bird.kernel { };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol bgp AS57695 {
        local as 133846;
        neighbor 2a0b:4342:ffff:: as 57695;
        multihop 2;
        source address 2a12:8d02:2100:2f3:5054:ff:fe34:d487;
        ipv6 {
          import none;
          export where net ~ [2602:feda:1bf::/48, 2a09:b280:ff84::/48];
        };
      }
    '';
  };
}
