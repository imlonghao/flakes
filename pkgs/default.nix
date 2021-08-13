final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  babeld = prev.callPackage ./babeld { };
  rait = prev.callPackage ./rait { };
}
