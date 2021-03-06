final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  rait = prev.callPackage ./rait { };
  pingfinder = prev.callPackage ./pingfinder { };
  etherguard = prev.callPackage ./etherguard { };
  powerdns = prev.callPackage ./powerdns { };
  q-dns = prev.callPackage ./q-dns { };
  deluge_exporter = prev.callPackage ./deluge_exporter { };
}
