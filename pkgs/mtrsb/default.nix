{ sources, buildGoModule, lib, pkgs, makeWrapper }:

buildGoModule rec {
  pname = "mtrsb";
  version = "cf6df5660779c9727a8a17cbed286a5971bed2d3";
  src = fetchgit {
    url = "https://git.esd.cc/imlonghao/mtr.sb";
    rev = "cf6df5660779c9727a8a17cbed286a5971bed2d3";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-7eR6+/MA9bvpL1/YOop3mAHrwf3aStcVpcD3ftMdKcY=";
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
