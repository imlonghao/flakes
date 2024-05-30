{ config, lib, profiles, ... }:
let
  generalConf = import profiles.bird.general {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
    route4 = ''
      route 172.22.68.0/27 blackhole;
      route 172.22.68.5/32 blackhole;

      route 23.146.88.240/29 blackhole;
    '';
    route6 = ''
      route fd21:5c0c:9b7e:5::/64 blackhole;
      route fd21:5c0c:9b7e:4242::/64 blackhole;

      route 2602:fab0:29:a::/64 via 2602:feda:1bf:deaf::20;
    '';
  };
  dn42Conf = import profiles.bird.dn42 { region = 44; country = 1840; ip = 5; config = config; lib = lib; };
in
{
  services.bird2 = {
    enable = true;
    config = generalConf + dn42Conf + ''
      protocol static {
        route 23.146.88.0/24 blackhole;
        ipv4 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 2));
            bgp_large_community.add((30114, 3, 840));
            accept;
          };
          export all;
        };
      }
      protocol static {
        route 2602:fab0:20::/48 blackhole;
        route 2602:fab0:29::/48 blackhole;
        ipv6 {
          import filter {
            bgp_large_community.add((30114, 1, 1));
            bgp_large_community.add((30114, 2, 2));
            bgp_large_community.add((30114, 3, 840));
            accept;
          };
          export all;
        };
      }
      protocol bgp AS53667v4 {
        local as 30114;
        neighbor 169.254.169.179 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv4 {
          import none;
          export filter {
            if net = 23.146.88.0/24 then {
              bgp_large_community.add((53667, 102, 174));
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
            if net = 23.146.88.240/29 then accept;
          };
        };
      }
      protocol bgp AS53667v6 {
        local as 30114;
        neighbor 2605:6400:ffff::2 as 53667;
        multihop 2;
        password "or2D7evY";
        ipv6 {
          import none;
          export filter {
            if net = 2602:fab0:20::/48 then {
              bgp_community.add((174, 140));
              bgp_large_community.add((53667, 102, 174));
              bgp_large_community.add((53667, 101, 6939));
            }
            if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
          };
        };
      }
    '';
  };
}
