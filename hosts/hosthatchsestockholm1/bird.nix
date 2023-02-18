{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = "";
    route6 = "";
  };
  kernelConf = import profiles.bird.kernel;
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + kernelConf + ''
      protocol babel {
        ipv4 {
          import all;
          export where net ~ 100.88.1.0/24 || source = RTS_BABEL;
        };
        ipv6 {
          import all;
          export where source = RTS_BABEL;
        };
        interface "vmesh" {
          type tunnel;
        };
      }
    '';
  };
}
