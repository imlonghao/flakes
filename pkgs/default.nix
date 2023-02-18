final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  rait = prev.callPackage ./rait { };
  pingfinder = prev.callPackage ./pingfinder { };
  etherguard = prev.callPackage ./etherguard { };
  q-dns = prev.callPackage ./q-dns { };
  deluge_exporter = prev.callPackage ./deluge_exporter { };
  bird-lg-go = prev.callPackage ./bird-lg-go { };
  tuic = prev.callPackage ./tuic { };
  coredns-nat64-rdns = prev.callPackage ./coredns-nat64-rdns { };
  wesher = prev.callPackage ./wesher { };
  mybird = prev.callPackage ./mybird { };
}
