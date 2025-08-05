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
      route 172.22.68.6/32 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:6::/64 blackhole;

      route 2602:feda:1bf::/48 blackhole;
      route 2a09:b280:ff83::/48 blackhole;
    '';
  };
  dn42Conf = import "${self}/profiles/bird/dn42.nix" {
    region = 41;
    country = 1578;
    ip = 6;
    config = config;
    lib = lib;
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" {
    dn42 = 6;
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
        protocol bgp AS56655a {
          neighbor 2a03:94e0:fef0:: as 56655;
          local as 133846;
          graceful restart on;
          multihop 3;
          ipv6 {
            import all;
            export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff83::/48;
          };
        }
        protocol bgp AS56655b {
          neighbor 	2a03:94e0:fff0:: as 56655;
          local as 133846;
          graceful restart on;
          multihop 3;
          ipv6 {
            import all;
            export where net = 2602:feda:1bf::/48 || net = 2a09:b280:ff83::/48;
          };
        }
      '';
  };
}
