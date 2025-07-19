{ config, self, ... }:
let
  generalConf = import "${self}/profiles/bird/general.nix" {
    config = config;
    ospf4 = "where net ~ 23.146.88.0/24";
  };
  kernelConf = import "${self}/profiles/bird/kernel.nix" { src6 = "2602:fab0:28::"; };
in
{
  services.bird = {
    enable = true;
    config =
      generalConf
      + kernelConf
      + ''
        protocol static {
          route 23.146.88.0/24 blackhole;
          ipv4 {
            import filter {
              bgp_community.add((21738, 211));
              bgp_community.add((21738, 349));
              bgp_community.add((21738, 359));
              bgp_community.add((21738, 369));

              bgp_large_community.add((30114, 1, 1));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              bgp_large_community.add((30114, 4, 35));
              accept;
            };
            export all;
          };
        }
        protocol static {
          route 2602:fab0:20::/48 blackhole;
          route 2602:fab0:28::/48 blackhole;
          route 2602:fab0:40::/44 blackhole;
          ipv6 {
            import filter {
              bgp_large_community.add((30114, 1, 1));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              bgp_large_community.add((30114, 4, 35));
              accept;
            };
            export all;
          };
        }

        # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -4b -l "define 'ARIN::AS-NOVA86-LLC::v4'" -R 24 ARIN::AS-NOVA86-LLC
        define 'ARIN::AS-NOVA86-LLC::v4' = [
          23.130.156.0/24
        ];
        # bgpq4 -S RPKI,AFRINIC,ARIN,APNIC,LACNIC,RIPE -6b -l "define 'ARIN::AS-NOVA86-LLC::v6'" -R 48 ARIN::AS-NOVA86-LLC
        define 'ARIN::AS-NOVA86-LLC::v6' = [
          2620:d1:2000::/48
        ];

        template bgp tmpl_upstream {
          local as 30114;
          graceful restart on;
          ipv4 {
            import filter {
              bgp_large_community.add((30114, 1, 2));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              accept;
            };
            export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
          };
          ipv6 {
            import filter {
              bgp_large_community.add((30114, 1, 2));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              accept;
            };
            export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
          };
        }
        template bgp tmpl_ixrs {
          local as 30114;
          graceful restart on;
          ipv4 {
            import filter {
              bgp_large_community.add((30114, 1, 4));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              accept;
            };
            export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
          };
          ipv6 {
            import filter {
              bgp_large_community.add((30114, 1, 4));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              accept;
            };
            export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
          };
        }
        template bgp tmpl_peer {
          local as 30114;
          graceful restart on;
          ipv4 {
            import none;
            export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
          };
          ipv6 {
            import none;
            export where bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)];
          };
        }

        protocol bgp AS21738v4 from tmpl_upstream {
          neighbor 23.150.40.66 as 21738;
          source address 23.150.40.72;
        };
        protocol bgp AS21738v6 from tmpl_upstream {
          neighbor 2602:2b7:40:64::66 as 21738;
          source address 2602:02b7:40:64::72;
          ipv6 {
            import none;
            export filter {
              if net = 2602:fab0:20::/48 then {
                bgp_path.prepend(30114);
                accept;
              }
              if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
            };
          };
        };

        protocol bgp AS25759v4 from tmpl_upstream {
          neighbor 23.150.40.88 as 25759;
          source address 23.150.40.72;
        };
        protocol bgp AS25759v6 from tmpl_upstream {
          neighbor 2602:2b7:40:64::88 as 25759;
          source address 2602:02b7:40:64::72;
          ipv6 {
            import none;
            export filter {
              if net = 2602:fab0:20::/48 then {
                bgp_path.prepend(30114);
                accept;
              }
              if bgp_large_community ~ [(30114, 1, 1), (30114, 1, 5)] then accept;
            };
          };
        };

        protocol bgp F4IX_1_v4 from tmpl_ixrs {
          neighbor 149.112.75.1 as 36090;
        };
        protocol bgp F4IX_2_v4 from tmpl_ixrs {
          neighbor 149.112.75.2 as 36090;
        };
        protocol bgp F4IX_1_v6 from tmpl_ixrs {
          neighbor 2602:fa3d:f4:1::1 as 36090;
        };
        protocol bgp F4IX_2_v6 from tmpl_ixrs {
          neighbor 2602:fa3d:f4:1::2 as 36090;
        };

        protocol bgp AS401538v4 from tmpl_peer {
          neighbor 149.112.75.13 as 401538;
          description "NOVA86 LLC";
          ipv4 {
            import filter {
              bgp_large_community.add((30114, 1, 3));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              if net ~ 'ARIN::AS-NOVA86-LLC::v4' then accept;
            };
          };
        };
        protocol bgp AS401538v6 from tmpl_peer {
          neighbor 2602:fa3d:f4:1::ca as 401538;
          description "NOVA86 LLC";
          ipv6 {
            import filter {
              bgp_large_community.add((30114, 1, 3));
              bgp_large_community.add((30114, 2, 2));
              bgp_large_community.add((30114, 3, 840));
              if net ~ 'ARIN::AS-NOVA86-LLC::v6' then accept;
            };
          };
        };

      '';
  };
}
