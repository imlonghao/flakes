{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/27 blackhole;
      route 172.22.68.3/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:3::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 {
    region = 52;
    country = 1344;
    ip = 3;
    config = config;
    lib = lib;
  };
in {
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + import profiles.bird.blackbgp { };
  };
}
