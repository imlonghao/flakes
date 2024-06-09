''
  protocol static {
    route 198.51.100.1/32 blackhole;
    ipv4;
  }
  protocol static {
    route 100::1/128 blackhole;
    ipv6;
  }
  protocol bgp blackbgp {
    neighbor 37.187.76.11 port 10179 as 65501;
    local as 65502;
    multihop 255;
    ipv4 {
      import all;
      export none;
    };
    ipv6 {
      import all;
      export none;
    };
  };
''
