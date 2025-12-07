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
  define DN42_NO_TRANSIT = [
    0
    , 4242423999 # COWGL-AS
  ];
  define DN42_AUTOPEER = [
    0
    # keep-sorted start
    , 4242420207 # ROUTEDBITS
    , 4242421588 # TECH9-CORE-NETWORK
    , 4242421816 # POTAT0-AS
    , 4242422189 # IEDON-NET-AS
    , 4242423035 # AS-LARE-DN42
    , 4242423088 # SUNNET
    , 4242423914 # Kioubit Network
    # keep-sorted end
  ];
  roa4 table dn42_roa;
  roa6 table dn42_roa_v6;
  protocol static {
    route 172.20.0.0/14 blackhole;
    route 172.22.68.0/27 blackhole;
    ipv4;
  }
  protocol static {
    route fd00::/8 blackhole;
    route fd21:5c0c:9b7e::/48 blackhole;
    ipv6;
  }
  function is_self_net() -> bool {
    case net.type {
      NET_IP4: return net = 172.22.68.0/27;
      NET_IP6: return net = fd21:5c0c:9b7e::/48;
    }
    return false;
  }
  function is_self_net_internal() -> bool {
    case net.type {
      NET_IP4: return net ~ 172.22.68.0/27;
      NET_IP6: return net ~ fd21:5c0c:9b7e::/48;
    }
    return false;
  }
  function is_self_net_detail() -> bool {
    case net.type {
      NET_IP4: return net ~ [172.22.68.0/27{28,32}];
      NET_IP6: return net ~ [fd21:5c0c:9b7e::/48{49,128}];
    }
    return false;
  }
  function is_valid_network() -> bool {
    case net.type {
      NET_IP4: return net ~ [
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
      NET_IP6: return net ~ [
        fd00::/8{44,64} # ULA address space as per RFC 4193
      ] && net != fd99:100:64:1::/64;
    }
    return false;
  }
  function roa_aio_check() -> bool {
    case net.type {
      NET_IP4: return roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID;
      NET_IP6: return roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID;
    }
    return false;
  }
  filter dn42_import_filter {
    if roa_aio_check() then {
      print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
      reject;
    }
    if !is_valid_network() || bgp_path ~ DN42_BLACKLIST_ASN then reject;
    if bgp_path ~ DN42_NO_TRANSIT && bgp_path.len > 1 then reject;
    if bgp_path ~ DN42_AUTOPEER then bgp_local_pref = bgp_local_pref - 10;
    if bgp_path.len = 1 then bgp_local_pref = bgp_local_pref + 10;
    if (64511, DN42_REGION) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
    if (64511, DN42_COUNTRY) ~ bgp_community then bgp_local_pref = bgp_local_pref + 10;
    bgp_large_community.add((4242421888, 100, DN42_REGION));
    bgp_large_community.add((4242421888, 101, DN42_COUNTRY));
    accept;
  }
  filter dn42_export_filter {
    if is_self_net_detail() then {
      reject;
    }
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
  filter internal_filter {
    if is_self_net_internal() && source ~ [RTS_STATIC, RTS_DEVICE] then {
      bgp_community.add((64511, DN42_REGION));
      bgp_community.add((64511, DN42_COUNTRY));
      accept;
    }
    if is_valid_network() && source ~ [RTS_STATIC, RTS_BGP] then {
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
      export filter internal_filter;
    };
    ipv6 {
      next hop self;
      import all;
      export filter internal_filter;
    };
  }
  protocol rpki rpki_dn42_imlonghao {
    roa4 { table dn42_roa; };
    roa6 { table dn42_roa_v6; };
    remote "103.167.150.135" port 8282;
    refresh 600;
    retry 300;
    expire 7200;
  }
  protocol rpki rpki_dn42_sunnet {
    roa4 { table dn42_roa; };
    roa6 { table dn42_roa_v6; };
    remote "rpki.dn42.6700.cc" port 8282;
    refresh 600;
    retry 300;
    expire 7200;
  }
  protocol rpki rpki_dn42_akae {
    roa4 { table dn42_roa; };
    roa6 { table dn42_roa_v6; };
    remote "rpki.akae.re" port 8082;
    refresh 600;
    retry 300;
    expire 7200;
  }
  template bgp dnpeers {
    local as 4242421888;
    enforce first as on;
    graceful restart on;
    long lived graceful restart on;
    prefer older on;
    bfd graceful;
    ipv4 {
      import keep filtered on;
      import table;
      extended next hop;
      import filter dn42_import_filter;
      export filter dn42_export_filter;
    };
    ipv6 {
      import keep filtered on;
      import table;
      import filter dn42_import_filter;
      export filter dn42_export_filter;
    };
  }
  protocol bgp flapalert {
    local as 4242421888;
    neighbor 100.64.1.19 port 1790 as 4242421888;
    ipv4 {
        add paths on;
        import none;
        export filter dn42_export_filter;
    };
    ipv6 {
        add paths on;
        import none;
        export filter dn42_export_filter;
    };
  }
  protocol bgp ROUTE_COLLECTOR {
    local as 4242421888;
    neighbor fd42:d42:d42:179::1 as 4242422602;
    multihop;
    ipv4 {
      add paths tx;
      import none;
      export filter dn42_export_filter;
    };
    ipv6 {
      add paths tx;
      import none;
      export filter dn42_export_filter;
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
