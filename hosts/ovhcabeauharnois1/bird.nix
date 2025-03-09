{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
  };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + kernelConf + import profiles.bird.blackbgp { };
  };
}
