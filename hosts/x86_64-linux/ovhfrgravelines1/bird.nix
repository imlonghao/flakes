{ config, self, ... }:
let
  generalConf = import "${self}/profiles/bird/general.nix" {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    ospf6 = "where net = 2602:fab0:31::/48";
    route4 = ''
      route 23.146.88.2/32 via 192.168.77.3;
      route 23.146.88.6/32 blackhole;
    '';
    route6 = ''
      route 2602:fab0:31::/48 blackhole;
    '';
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" { src6 = "2602:fab0:31:1::"; };
in
{
  services.bird = {
    enable = true;
    config =
      generalConf
      + kernelConf
      + import "${self}/profiles/bird/blackbgp.nix" { }
      + ''
        ipv4 table as199632v4;
        ipv6 table as199632v6;
        protocol static {
          ipv4 { table as199632v4; };
          route 0.0.0.0/0 via 100.64.1.5;
          route 100.64.88.0/24 via "eg_net";
        }
        protocol static {
          ipv6 { table as199632v6; };
          route 2602:fab0:31:1::/64 via "virbr1";
          route 2602:feda:1bf:deaf::/64 via "eg_net";
        }
        protocol kernel kern199632v4 {
          ipv4 {
            table as199632v4;
            export filter {
              krt_prefsrc = 23.146.88.6;
              accept;
            };
          };
          kernel table 199632;
        }
        protocol kernel kern199632v6 {
          ipv6 {
            table as199632v6;
            export filter {
              krt_prefsrc = 2602:fab0:31:1::;
              accept;
            };
          };
          kernel table 199632;
        }
        protocol pipe {
          table master4;
          peer table as199632v4;
          import none;
          export all;
        }
      '';
  };
}
