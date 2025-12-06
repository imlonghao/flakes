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
      route 172.22.68.2/32 blackhole;
      route 172.22.68.8/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e::/64 blackhole;
      route fd21:5c0c:9b7e::8/128 blackhole;
      route fd21:5c0c:9b7e:2::/64 blackhole;
    '';
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 51;
    country = 1702;
    ip = 2;
    config = config;
    lib = lib;
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" {
    dn42 = 2;
  };
in
{
  services.bird = {
    enable = true;
    config = generalConf + dn42Conf + kernelConf;
  };
}
