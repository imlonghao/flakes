{ fetchgit, buildGoModule, lib, pkgs, makeWrapper }:

buildGoModule rec {
  pname = "chrony_exporter";
  version = "1.0.1";
  src = fetchgit {
    url = "https://git.esd.cc/imlonghao/prometheus-chrony-exporter";
    rev = "1.0.1";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-5/HO2JhmXtQ6AtHIWsJ8J6JW/rFp6DaLxRXdOVbJQx0=";
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
