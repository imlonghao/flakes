{ lib, stdenv, bird-babel-rtt, python3, strongswan }:
stdenv.mkDerivation rec {
  pname = "ranetdebug";
  version = "1.0.0";

  src = ./ranet.py;
  dontUnpack = true;

  propagatedBuildInputs = [ bird-babel-rtt python3 strongswan ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    substitute "${src}" "$out/bin/ranetdebug" \
               --replace "#!/usr/bin/env python" "#!${python3}/bin/python" \
               --replace birdc "${bird-babel-rtt}/bin/birdc" \
               --replace swanctl "${strongswan}/bin/swanctl"
    chmod +x "$out/bin/ranetdebug"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Debug DN42 peer";
    homepage = "https://imlonghao.com";
    license = licenses.mit;
    platforms = platforms.gnu;
  };
}
