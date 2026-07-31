{
  fetchurl,
  iputils,
  lib,
  makeWrapper,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "peerfinder-agent";
  version = "1.0.6";

  src = fetchurl {
    url = "https://peerfinder.dn42.dev/agent/peerfinder-agent.py";
    hash = "sha256-BQqbTJGkYMFZYV9G/VnvP2Ma8QVbo5CGJqs2WhYUJjo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/peerfinder-agent"
    substituteInPlace "$out/bin/peerfinder-agent" \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe python3}'
    wrapProgram "$out/bin/peerfinder-agent" \
      --prefix PATH : ${lib.makeBinPath [ iputils ]}

    runHook postInstall
  '';

  meta = {
    description = "Measurement agent for the dn42 Peer Finder";
    homepage = "https://peerfinder.dn42.dev";
    mainProgram = "peerfinder-agent";
    platforms = lib.platforms.linux;
  };
}
