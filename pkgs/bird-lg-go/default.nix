{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule rec {
  pname = "bird-lg-go";
  version = "1.3.10";
  src = fetchFromGitHub ({
    owner = "xddxdd";
    repo = "bird-lg-go";
    rev = "v${version}";
    sha256 = "sha256-PIdy0hypwhPBmtn2GtptRNhACfNj8QLzEQA1onJ/v9k=";
  });

  modRoot = "proxy";

  vendorHash = "sha256-MAR+4o+BKd24uOpgcwsfMWoKWbRYxrCG6tMCrH8LS7Y=";

  meta = {
    description = "BIRD looking glass in Go, for better maintainability, easier deployment & smaller memory footprint";
    homepage = "https://github.com/xddxdd/bird-lg-go";
    license = lib.licenses.gpl3Only;
  };
}
