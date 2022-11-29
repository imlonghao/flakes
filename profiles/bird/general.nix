{ config, ... }:
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
''