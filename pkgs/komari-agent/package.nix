{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
}:
buildGoModule rec {
  pname = "komari-agent";
  version = "1.1.34";

  src = fetchFromGitHub {
    owner = "komari-monitor";
    repo = pname;
    rev = version;
    hash = "sha256-7+AdA80wgDso6wlR65eG3W0+EWBM29oBsq4bynzZIG4=";
  };

  vendorHash = "sha256-5RL/dDR/Or9GRCPVQmUYKTV82q7xuN2Mqc4/86WmbqY=";

  ldflags = [
    "-s -w"
    "-X=github.com/komari-monitor/komari-agent/update.CurrentVersion=${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
  ];

  meta = with lib; {
    homepage = "https://github.com/komari-monitor/komari-agent";
    description = "A lightweight server probe for simple, efficient monitoring";
    license = licenses.mit;
  };
}
