{
  config,
  lib,
  self,
  ...
}:
let
  generalConf = import "${self}/profiles/bird/general.nix" {
    config = config;
    route4 = ''
      route 172.22.68.0/27 blackhole;
      route 172.22.68.4/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:4::/64 blackhole;
    '';
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 41;
    country = 1276;
    ip = 4;
    config = config;
    lib = lib;
  };
in
{
  services.bird = {
    enable = true;
    config = generalConf + dn42Conf;
  };
}
