{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
  };
  kernelConf = import profiles.bird.kernel;
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + kernelConf;
  };
}
