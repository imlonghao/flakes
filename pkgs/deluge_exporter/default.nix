{ sources, lib, stdenv, python3Packages }:

stdenv.mkDerivation rec {
  inherit (sources.deluge_exporter) pname version src;

  propagatedBuildInputs = with python3Packages; [
    deluge-client
    loguru
    prometheus-client
  ];

  buildPhase = "true";

  installPhase = ''
    runHook preInstall
    install -Dm755 "${src}/deluge_exporter.py" "$out/bin/deluge_exporter"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Prometheus exporter for the Deluge BitTorrent client";
    homepage = "https://github.com/tobbez/deluge_exporter";
    license = licenses.isc;
  };
}
