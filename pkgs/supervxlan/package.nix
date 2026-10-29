{
  buildGoModule,
  fetchFromGitea,
  lib,
}:

buildGoModule rec {
  pname = "supervxlan";
  version = "e84674010721bd764c0d10f4ba58e7b0dfbb0298";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-jhRGloNMzHTH0/MuV68kh32VWVAaSuzqGxUKo+UHzrk=";
  };
  vendorHash = "sha256-SJazRQj8GTz3z451RyyGYpuys0qg9P/rqCu/gfzJf3k=";

  subPackages = [ "cmd/agent" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  postInstall = ''
    mv $out/bin/agent $out/bin/supervxlan
  '';

  meta = with lib; {
    description = "A tool for managing VXLAN networks";
    homepage = "https://github.com/imlonghao/supervxlan";
    license = licenses.mit;
  };
}
