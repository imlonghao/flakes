{ src4 ? "", src6 ? "" }:
let
  ssrc4 = if src4 == "" then "" else "krt_prefsrc = ${src4};";
  ssrc6 = if src6 == "" then "" else "krt_prefsrc = ${src6};";
in ''
  protocol kernel {
    scan time 10;
    graceful restart on;
    ipv4 {
      import none;
      export filter {
        if net = 0.0.0.0/0 then reject;
        if source = RTS_DEVICE then reject;
        ${ssrc4}
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
        if source = RTS_DEVICE then reject;
        ${ssrc6}
        accept;
      };
    };
  }
''
