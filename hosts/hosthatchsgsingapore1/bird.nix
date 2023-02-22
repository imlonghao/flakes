{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 172.22.68.0/28 blackhole;
      route 172.22.68.2/32 blackhole;
      route 172.22.68.8/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e::/64 blackhole;
      route fd21:5c0c:9b7e::8/128 blackhole;
      route fd21:5c0c:9b7e:2::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 51; country = 1702; ip = 2; config = config; lib = lib; };
in
{
  services.mybird2 = {
    enable = true;
    config = generalConf + dn42Conf;
  };
}
