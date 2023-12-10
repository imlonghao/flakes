{ fetchFromGitHub, buildGoModule, lib }:
let
  repo = fetchFromGitHub ({
    owner = "xddxdd";
    repo = "bird-lg-go";
    rev = "v1.0.0";
    sha256 = "sha256-Fm1upm/jMnT3Lx1zPD75uYEfoF9mpQK12kR80Gm/mFw=";
  });
in
buildGoModule rec {
  pname = "bird-lg-go";
  version = "v1.0.0";
  src = "${repo}/proxy";

  vendorHash = "sha256-b4Md/LdwNhbKVXdnZ+LO4J/Y0hxBrCcvTW8J1mmysaY=";

  meta = {
    description = "BIRD looking glass in Go, for better maintainability, easier deployment & smaller memory footprint";
    homepage = "https://github.com/xddxdd/bird-lg-go";
    license = lib.licenses.gpl3Only;
  };
}
