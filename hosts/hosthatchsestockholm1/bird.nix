{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = "";
    route6 = "";
  };
  kernelConf = import profiles.bird.kernel { };
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + kernelConf;
  };
}
