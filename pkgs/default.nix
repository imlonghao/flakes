final: prev: {
  bird-lg-go = prev.callPackage ./bird-lg-go { };
  chrony_exporter = prev.callPackage ./chrony_exporter { };
  coredns-nat64-rdns = prev.callPackage ./coredns-nat64-rdns { };
  deluge_exporter = prev.callPackage ./deluge_exporter { };
  dn42debug = prev.callPackage ./dn42debug { };
  etherguard = prev.callPackage ./etherguard { };
  juicity = prev.callPackage ./juicity { };
  mtrsb = prev.callPackage ./mtrsb { };
  pingfinder = prev.callPackage ./pingfinder { };
  wtt = prev.callPackage ./wtt { };
  hachimi = prev.callPackage ./hachimi { };
  bird-babel-rtt = prev.callPackage ./bird-babel-rtt { };
}
