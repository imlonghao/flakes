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
      route 172.22.68.13/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:13::/64 blackhole;
    '';
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 42;
    country = 1840;
    ip = 13;
    config = config;
    lib = lib;
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" {
    dn42 = 13;
  };
in
{
  services.bird = {
    enable = true;
    config = generalConf + dn42Conf + kernelConf;
  };
}
