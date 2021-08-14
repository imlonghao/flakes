final: prev: {
  babeld = prev.babeld.overrideAttrs (o: rec{
    inherit (prev.sources.babeld) pname version src;
  });
}
