{ sources, lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  inherit (sources.deluge_exporter) pname version src;

  propagatedBuildInputs = [
    (pkgs.python3.withPackages(ps: with ps; [ 
      deluge-client
      loguru
      prometheus-client
    ]))
  ];

  buildPhase = "true";

  installPhase = ''
    runHook preInstall
    install -Dm755 "${src}/deluge_exporter.py" "$out/bin/deluge_exporter"
    install -Dm644 "${src}/libtorrent_metrics.json" "$out/bin/libtorrent_metrics.json"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Prometheus exporter for the Deluge BitTorrent client";
    homepage = "https://github.com/tobbez/deluge_exporter";
    license = licenses.isc;
  };
}
