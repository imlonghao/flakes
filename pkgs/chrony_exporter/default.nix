{ fetchgit, buildGoModule, lib, pkgs, makeWrapper }:

buildGoModule rec {
  pname = "chrony_exporter";
  version = "796d32a9a4f686a15e61c58217962a2ec931db5b";
  src = fetchgit {
    url = "https://git.esd.cc/imlonghao/prometheus-chrony-exporter";
    rev = "796d32a9a4f686a15e61c58217962a2ec931db5b";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-fi7Ikp1TRuZ+0svh8jTngFBKoIBUMOKuwNdT9KvZi6o=";
  };
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
