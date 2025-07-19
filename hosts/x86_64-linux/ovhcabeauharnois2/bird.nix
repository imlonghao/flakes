{ config, self, ... }:
let
  generalConf = import "${self}/profiles/bird/general.nix" { config = config; };
in
{
  services.bird = {
    enable = true;
    config =
      generalConf
      + import "${self}/profiles/bird/kernel.nix" { }
      + import "${self}/profiles/bird/blackbgp.nix" { };
  };
}
