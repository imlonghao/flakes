{ lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "dn42debug";
  version = "1.0.0";

  src = ./dn42debug.sh;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D "${src}" "$out/bin/dn42debug"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Debug DN42 peer";
    homepage = "https://imlonghao.com";
    license = licenses.mit;
    platforms = platforms.gnu;
  };
}
