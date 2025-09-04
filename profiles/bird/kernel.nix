{
  src4 ? "",
  src6 ? "",
  dn42 ? 0,
}:
let
  ssrc4 = if src4 == "" then "" else "krt_prefsrc = ${src4};";
  ssrc6 = if src6 == "" then "" else "krt_prefsrc = ${src6};";
  dn42_v4 =
    if dn42 == 0 then
      ""
    else
      "if is_valid_network() then { krt_prefsrc = 172.22.68.${toString dn42}; accept; }";
  dn42_v6 =
    if dn42 == 0 then
      ""
    else
      "if is_valid_network() then { krt_prefsrc = fd21:5c0c:9b7e:${toString dn42}::1; accept; }";
in
''
  protocol kernel {
    scan time 10;
    graceful restart on;
    ipv4 {
      import none;
      export filter {
        if net = 0.0.0.0/0 then reject;
        if source = RTS_DEVICE then reject;
        ${dn42_v4}
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
        ${dn42_v6}
        ${ssrc6}
        accept;
      };
    };
  }
''
