{ sources, buildGoModule, lib, pkgs, makeWrapper }:

buildGoModule rec {
  inherit (sources.chrony_exporter) pname version src;
  vendorHash = "sha256-WF9KDpm98dVVLcoE/b0y3aac/pTvSqoYmSF+OOpsB5o=";
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/prometheus-chrony-exporter --suffix PATH : ${lib.makeBinPath [ pkgs.chrony ]}
  '';
  meta = with lib; {
    description = "Prometheus Chrony Exporter";
    license = licenses.mit;
  };
}
