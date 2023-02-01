{ region, country, ip, config, lib }:
''
  define DN42_REGION = ${toString region};
  define DN42_COUNTRY = ${toString country};
  function is_martian_v4() {
    return net ~ [
      0.0.0.0/8+,
      10.0.0.0/8+,
      100.64.0.0/10+,
      127.0.0.0/8+,
      169.254.0.0/16+,
      172.16.0.0/12+,
      192.0.2.0/24+,
      192.88.99.0/24+,
      192.168.0.0/16+,
      193.254.225.0/24+,
      198.18.0.0/15+,
      198.51.100.0/24+,
      203.0.113.0/24+,
      224.0.0.0/4+,
      240.0.0.0/4+
    ];
  }
  function is_martian_v6() {
    return net ~ [
      ::/8+,
      ::ffff:0.0.0.0/96+,
      ::/96,
      ::/128,
      ::1/128,
      0000::/8+,
      0100::/64+,
      0200::/7+,
      2001:2::/48+,
      2001:10::/28+,
      2001:db8::/32+,
      2002:e000::/20+,
      2002:7f00::/24+,
      2002:0000::/24+,
      2002:ff00::/24+,
      2002:0a00::/24+,
      2002:ac10::/28+,
      2002:c0a8::/32+,
      3ffe::/16+,
      fc00::/7+,
      fe80::/10+,
      fec0::/10+,
      ff00::/8+
    ];
  }
  function is_valid_network() {
    return net ~ [
      172.20.0.0/14{21,29}, # dn42
      172.20.0.0/24{28,32}, # dn42 Anycast
      172.21.0.0/24{28,32}, # dn42 Anycast
      172.22.0.0/24{28,32}, # dn42 Anycast
      172.23.0.0/24{28,32}, # dn42 Anycast
      172.31.0.0/16+,       # ChaosVPN
      10.100.0.0/14+,       # ChaosVPN
      10.127.0.0/16{16,32}, # neonetwork
      10.0.0.0/8{15,24}     # Freifunk.net
    ];
  }
  function is_valid_network_v6() {
    return net ~ [
      fd00::/8{44,64} # ULA address space as per RFC 4193
    ];
  }
  protocol kernel {
    scan time 10;
    graceful restart on;
    ipv4 {
      import none;
      export filter {
        if net = 0.0.0.0/0 then reject;
        if is_valid_network() then krt_prefsrc = 172.22.68.${toString ip};
        accept;
      };
    };
  }
  protocol kernel {
    scan time 10;
    graceful restart on;
    ipv6 {
      import none;
      export filter {
        if net = ::/0 then reject;
        if is_valid_network_v6() then krt_prefsrc = fd21:5c0c:9b7e:${toString ip}::;
        accept;
      };
    };
  }
  protocol bgp RR {
    local as 4242421888;
    neighbor internal;
    neighbor fe80::dcad:beff:feef:1;
    interface "eg_net";
    direct;
    ipv4 {
      next hop self;
      import all;
      export all;
    };
    ipv6 {
      next hop self;
      import all;
      export all;
    };
  }
  roa4 table dn42_roa;
  roa6 table dn42_roa_v6;
  protocol rpki rpki_dn42{
    roa4 { table dn42_roa; };
    roa6 { table dn42_roa_v6; };
    remote "103.167.150.135" port 8282;
    retry keep 90;
    refresh keep 900;
    expire keep 172800;
  }
  template bgp dnpeers {
    local as 4242421888;
    graceful restart on;
    ipv4 {
      import keep filtered on;
      import table;
      extended next hop;
      import filter {
        if (roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID) then {
          print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
          reject;
        }
        if !is_valid_network() then {
          reject;
        }
        if bgp_path.len = 1 then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        accept;
      };
      export filter {
        if !is_valid_network() then {
          reject;
        }
        if source = RTS_STATIC then {
          bgp_community.add((64511, DN42_REGION));
          bgp_community.add((64511, DN42_COUNTRY));
        }
        accept;
      };
    };
    ipv6 {
      import keep filtered on;
      import table;
      import filter {
        if (roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID) then {
          print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
          reject;
        }
        if !is_valid_network_v6() then {
          reject;
        }
        if bgp_path.len = 1 then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        accept;
      };
      export filter {
        if !is_valid_network_v6() then {
          reject;
        }
        if source = RTS_STATIC then {
          bgp_community.add((64511, DN42_REGION));
          bgp_community.add((64511, DN42_COUNTRY));
        }
        accept;
      };
    };
  }
  ${builtins.concatStringsSep "\n" (lib.flip map (config.dn42) (x:
    if x.mpbgp then
    ''
      protocol bgp AS${builtins.toString x.asn} from dnpeers {
        neighbor ${x.e6} % '${x.name}' as ${toString x.asn};
      }
    '' else
    ''
      protocol bgp AS${builtins.toString x.asn}v4 from dnpeers {
        neighbor ${x.e4} as ${toString x.asn};
      }
      protocol bgp AS${builtins.toString x.asn}v6 from dnpeers {
        neighbor ${x.e6} % '${x.name}' as ${toString x.asn};
      }
    ''
    ))}
''
