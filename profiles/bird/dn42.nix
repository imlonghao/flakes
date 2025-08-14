{
  region,
  country,
  ip,
  config,
  lib,
}:
''
  define DN42_REGION = ${toString region};
  define DN42_COUNTRY = ${toString country};
  define DN42_BLACKLIST_ASN = [
    0
    , 4242423658 # Jason Xu
  ];
  function is_self_net() {
    return net ~ 172.22.68.0/27;
  }
  function is_self_net_v6() {
    return net ~ fd21:5c0c:9b7e::/48;
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
    ] && net != fd99:100:64:1::/64;
  }
  filter dn42_filter_v4 {
    if is_valid_network() && source ~ [RTS_STATIC, RTS_BGP, RTS_DEVICE] then {
      if source ~ [RTS_STATIC, RTS_DEVICE] then {
        if is_self_net() then {
          bgp_community.add((64511, DN42_REGION));
          bgp_community.add((64511, DN42_COUNTRY));
          accept;
        }
        reject;
      }
      accept;
    }
    reject;
  }
  filter dn42_filter_v6 {
    if is_valid_network_v6() && source ~ [RTS_STATIC, RTS_BGP, RTS_DEVICE] then {
      if source ~ [RTS_STATIC, RTS_DEVICE] then {
        if is_self_net_v6() then {
          bgp_community.add((64511, DN42_REGION));
          bgp_community.add((64511, DN42_COUNTRY));
          accept;
        }
        reject;
      }
      accept;
    }
    reject;
  }
  protocol bgp RR {
    local as 4242421888;
    neighbor internal;
    neighbor fd99:100:64:1::4;
    interface "gravity";
    direct;
    ipv4 {
      next hop self;
      import all;
      export filter {
        if is_self_net() && source ~ [RTS_STATIC, RTS_DEVICE] then {
          bgp_community.add((64511, DN42_REGION));
          bgp_community.add((64511, DN42_COUNTRY));
          accept;
        }
        if is_valid_network() && source ~ [RTS_STATIC, RTS_BGP] then {
          accept;
        }
        reject;
      };
    };
    ipv6 {
      next hop self;
      import all;
      export filter {
        if is_self_net_v6() && source ~ [RTS_STATIC, RTS_DEVICE] then {
          bgp_community.add((64511, DN42_REGION));
          bgp_community.add((64511, DN42_COUNTRY));
          accept;
        }
        if is_valid_network_v6() && source ~ [RTS_STATIC, RTS_BGP] then {
          accept;
        }
        reject;
      };
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
    long lived graceful restart on;
    prefer older on;
    ipv4 {
      import keep filtered on;
      import table;
      extended next hop;
      import filter {
        if (roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID) then {
          print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
          reject;
        }
        if !is_valid_network() || bgp_path ~ DN42_BLACKLIST_ASN then {
          reject;
        }
        if bgp_path.len = 1 then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        bgp_large_community.add((4242421888, 100, DN42_REGION));
        bgp_large_community.add((4242421888, 101, DN42_COUNTRY));
        accept;
      };
      export filter dn42_filter_v4;
    };
    ipv6 {
      import keep filtered on;
      import table;
      import filter {
        if (roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID) then {
          print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
          reject;
        }
        if !is_valid_network_v6() || bgp_path ~ DN42_BLACKLIST_ASN then {
          reject;
        }
        if bgp_path.len = 1 then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
        bgp_large_community.add((4242421888, 100, DN42_REGION));
        bgp_large_community.add((4242421888, 101, DN42_COUNTRY));
        accept;
      };
      export filter dn42_filter_v6;
    };
  }
  protocol bgp flapalert {
    local as 4242421888;
    neighbor 100.64.1.19 port 1790 as 4242421888;
    ipv4 {
        add paths on;
        export all;
        import none;
    };
    ipv6 {
        add paths on;
        export all;
        import none;
    };
  }
  ${builtins.concatStringsSep "\n" (
    lib.flip map (config.dn42.peers) (
      x:
      if x.mpbgp then
        ''
          protocol bgp AS${builtins.toString x.asn} from dnpeers {
            neighbor ${x.e6} % '${x.name}' as ${toString x.asn};
          }
        ''
      else
        ''
          protocol bgp AS${builtins.toString x.asn}v4 from dnpeers {
            neighbor ${x.e4} as ${toString x.asn};
          }
          protocol bgp AS${builtins.toString x.asn}v6 from dnpeers {
            neighbor ${x.e6} % '${x.name}' as ${toString x.asn};
          }
        ''
    )
  )}
''
