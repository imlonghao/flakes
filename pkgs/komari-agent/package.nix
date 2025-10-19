{
  lib,
  fetchFromGitHub,
  buildGoModule,
  vnstat,
  makeWrapper,
}:
buildGoModule rec {
  pname = "komari-agent";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "komari-monitor";
    repo = pname;
    rev = version;
    hash = "sha256-DcSI206Lm4h933pKmywrtcg52Atp+ow6wJiPFNS23ms=";
  };

  vendorHash = "sha256-m2XD3KgMnetpgDontK8Kk+PRHcqM2eLV2NvikR5zAWg=";

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
