{ config, ospf4 ? "none", ospf6 ? "none", route4, route6 }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ] config.services.etherguard-edge.ipv4;
in
''
  router id ${ip};
  timeformat protocol iso long;
  protocol direct {
    ipv4;
    ipv6;
  }
  protocol device {
    scan time 10;
  }
  protocol static {
    ${route4}
    ipv4 {
      import all;
      export all;
    };
  }
  protocol static {
    ${route6}
    ipv6 {
      import all;
      export all;
    };
  }
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
  protocol ospf v3 intranet_v4 {
    ipv4 {
      import all;
      export ${ospf4};
    };
    area 0 {
      interface "eg_net" {
        type bcast;
      };
    };
  }
  protocol ospf v3 intranet_v6 {
    ipv6 {
      import all;
      export ${ospf6};
    };
    area 0 {
      interface "eg_net" {
        type bcast;
      };
    };
  }
''
