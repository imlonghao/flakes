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
      route 172.22.68.11/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:11::/64 blackhole;
    '';
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 43;
    country = 1840;
    ip = 11;
    config = config;
    lib = lib;
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" {
    dn42 = 11;
  };
in
{
  services.bird = {
    enable = true;
    config =
      generalConf
      + dn42Conf
      + kernelConf
      + ''
        protocol bgp AS4201270000 from dnpeers {
          neighbor 2602:fab0:41::42:0127:0000 as 4201270000;
        }
        protocol bgp AS4242420458 from dnpeers {
          neighbor fe80::42:4242:0458 % 'ens18' as 4242420458;
        }
        protocol bgp AS4242422032 from dnpeers {
          neighbor fe80::42:4242:2032 % 'ens18' as 4242422032;
        }
      '';
  };
}
