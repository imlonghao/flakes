{ config, profiles, ... }:
let
  generalConf = import profiles.bird.general { config = config; };
in
{
  services.bird = {
    enable = true;
    config = generalConf + import profiles.bird.kernel { } + import profiles.bird.blackbgp { };
  };
}
