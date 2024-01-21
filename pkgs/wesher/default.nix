{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "wesher";
  version = "17d92b16af06de5ee6014d1e58dcc6fb71260878";
  src = fetchFromGitHub {
    owner = "costela";
    repo = "wesher";
    rev = "17d92b16af06de5ee6014d1e58dcc6fb71260878";
    fetchSubmodules = false;
    sha256 = "sha256-wzWPhS59YcCdcRFMF0j95pX1xgkGFBl8ChthZyYTgEA=";
  };
  vendorHash = "sha256-QoIwp475/+QDYY65TG4DaFH5wbM5eQGREuIJCbBLFy0=";

  meta = with lib; {
    description = "wireguard overlay mesh network manager";
    homepage = "https://github.com/costela/wesher";
    license = licenses.gpl3Plus;
  };
}
