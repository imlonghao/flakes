{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    route4 = ''
      route 44.31.42.0/24 blackhole;
      route 172.22.68.0/28 blackhole;
      route 172.22.68.5/32 blackhole;
    '';
    route6 = ''
      route 2a09:b280:ff82::/48 blackhole;
      route fd21:5c0c:9b7e:5::/64 blackhole;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 44; country = 1840; ip = 5; config = config; lib = lib; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol bgp AS53667v4 {
        local as 133846;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv4 {
          import none;
          export filter {
            if net = 44.31.42.0/24 then {
              bgp_path.prepend(133846);
              bgp_path.prepend(133846);
              bgp_large_community.add((53667, 109, 6939));
              accept;
            }
          };
        };
      }
      protocol bgp AS53667v6 {
        local as 133846;
        neighbor 2605:6400:ffff::2 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv6 {
          import none;
          export where net = 2a09:b280:ff82::/48;
        };
      }
    '';
  };
}
