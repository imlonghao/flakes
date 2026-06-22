{ config, self, ... }:
let
  generalConf = import "${self}/profiles/bird/general.nix" {
    config = config;
    rip4 = "where net = 172.22.68.16/30";
    rip6 = "where net = fd21:5c0c:9b7e:3:1::/80";
    route4 = ''
      route 172.20.0.0/14 via 100.64.1.30;
      route 10.0.0.0/8 via 100.64.1.30;
    '';
    route6 = ''
      route fd00::/8 via fd99:100:64:1::30;
    '';
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" { };
in
{
  services.bird = {
    enable = true;
    config = generalConf + kernelConf;
  };
}
