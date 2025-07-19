{ config, self, ... }:
let
  generalConf = import "${self}/profiles/bird/general.nix" {
    config = config;
    route4 = "";
    route6 = "";
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" { };
in
{
  services.bird = {
    enable = true;
    config = generalConf + kernelConf;
  };
}
