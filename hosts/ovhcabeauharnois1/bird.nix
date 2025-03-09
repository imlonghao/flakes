{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
  };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + import profiles.bird.blackbgp { }
  };
}
