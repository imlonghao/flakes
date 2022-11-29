{ config, route4, route6 }:
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
''
