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
    config = generalConf + kernelConf;
  };
}
