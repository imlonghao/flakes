{
  fetchFromGitHub,
  lib,
  stdenv,
  pkgs,
}:

stdenv.mkDerivation rec {
  pname = "deluge_exporter";
  version = "47feca92f13f210a093a879fd88871ab4329dacd";
  src = fetchFromGitHub {
    owner = "tobbez";
    repo = "deluge_exporter";
    rev = "47feca92f13f210a093a879fd88871ab4329dacd";
    fetchSubmodules = false;
    sha256 = "sha256-FCi1dimd5MW+eFPBn/D1WoXVCRwn9LK0HzHfsv3I0Uo=";
  };

  propagatedBuildInputs = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        deluge-client
        loguru
        prometheus-client
      ]
    ))
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
