# SPDX-FileCopyrightText: 2020 Aluísio Augusto Silva Gonçalves <https://aasg.name>
# SPDX-License-Identifier: MIT

{ lib
, stdenv
, makeWrapper
, writeScriptBin
, coreutils
, curl
, gnugrep
, iputils
, which
}:
let silentWhich = writeScriptBin "which" ''
  exec "${which}/bin/which" "$@" 2>/dev/null
'';
in
stdenv.mkDerivation rec {
  pname = "pingfinder";
  version = "r49-4a185c375c";

  src = ./generic-linux-debian-redhat-busybox.sh;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm 0755 "${src}" "$out/bin/pingfinder"
    ls -al "$out/bin/"
    pwd
    wrapProgram "$out/bin/pingfinder" --set PATH "${lib.makeBinPath [
      coreutils
      curl
      gnugrep
      iputils
      silentWhich
    ]}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Measurement script for the dn42 peer finder";
    homepage = "https://dn42.us/peers";
    license = licenses.bsd2;
    platforms = platforms.gnu;
  };
}
