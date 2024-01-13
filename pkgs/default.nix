final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  rait = prev.callPackage ./rait { };
  pingfinder = prev.callPackage ./pingfinder { };
  etherguard = prev.callPackage ./etherguard { };
  deluge_exporter = prev.callPackage ./deluge_exporter { };
  bird-lg-go = prev.callPackage ./bird-lg-go { };
  coredns-nat64-rdns = prev.callPackage ./coredns-nat64-rdns { };
  wesher = prev.callPackage ./wesher { };
  mybird = prev.callPackage ./mybird { };
  wtt = prev.callPackage ./wtt { };
  mtrsb = prev.callPackage ./mtrsb { };
  chrony_exporter = prev.callPackage ./chrony_exporter { };
  juicity = prev.callPackage ./juicity { };
}
