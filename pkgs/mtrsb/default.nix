{ fetchgit, buildGoModule, lib, pkgs, makeWrapper }:

buildGoModule rec {
  pname = "mtrsb";
  version = "v1.1.2";
  src = fetchgit {
    url = "https://git.esd.cc/imlonghao/mtr.sb";
    rev = "v1.1.2";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-tB0fWQIpZzme/4hywG3VvgRFRBRdbzPEExiH2gSdlrA=";
  };
  vendorHash = "sha256-nM2aCJollBdadvzBJm1VTE5QzLL2kg6YdKVE03En9Io=";
  subPackages = [ "cmd/worker" ];
  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/worker --suffix PATH : ${lib.makeBinPath [ pkgs.iputils pkgs.traceroute pkgs.mtr ]}
  '';
  meta = with lib; {
    description = "MTR.SB Worker";
    license = licenses.mit;
  };
}
