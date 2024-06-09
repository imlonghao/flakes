# SPDX-FileCopyrightText: 2020 Aluísio Augusto Silva Gonçalves <https://aasg.name>
# SPDX-License-Identifier: MIT

{ lib, stdenv, makeWrapper, writeScriptBin, coreutils, curl, gnugrep, iputils
, which, util-linux }:
let
  silentWhich = writeScriptBin "which" ''
    exec "${which}/bin/which" "$@" 2>/dev/null
  '';
in stdenv.mkDerivation rec {
  pname = "pingfinder";
  version = "r52-8fd1af682d";

  src = ./generic-linux-debian-redhat-busybox.sh;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -D "${src}" "$out/bin/pingfinder"
    wrapProgram "$out/bin/pingfinder" --set PATH "${
      lib.makeBinPath [ coreutils curl gnugrep iputils silentWhich util-linux ]
    }"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Measurement script for the dn42 peer finder";
    homepage = "https://dn42.us/peers";
    license = licenses.bsd2;
    platforms = platforms.gnu;
  };
}
