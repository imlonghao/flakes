{
  lib,
  fetchFromGitHub,
  buildGoModule,
  vnstat,
  makeWrapper,
}:
buildGoModule rec {
  pname = "komari-agent";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "komari-monitor";
    repo = pname;
    rev = version;
    hash = "sha256-AllLRP5GrZKrt8qLnMjOsMXrSTND/uggAVPnKYLtp9w=";
  };

  vendorHash = "sha256-2tCYq7+r2VCQTULEt7gkK3ocz3YSoKi9yZ7NCVUTiH8=";

  ldflags = [
    "-s -w"
    "-X=github.com/komari-monitor/komari-agent/update.CurrentVersion=${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/komari-agent \
     --prefix PATH : ${lib.makeBinPath [ vnstat ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/komari-monitor/komari-agent";
    description = "A lightweight server probe for simple, efficient monitoring";
    license = licenses.mit;
  };
}
