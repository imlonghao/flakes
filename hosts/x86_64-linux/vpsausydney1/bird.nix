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
      route 172.22.68.9/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:9::/64 blackhole;
    '';
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 53;
    country = 1036;
    ip = 9;
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
