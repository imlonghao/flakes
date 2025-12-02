{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
}:
buildGoModule rec {
  pname = "komari-agent";
  version = "1.1.38";

  src = fetchFromGitHub {
    owner = "komari-monitor";
    repo = pname;
    rev = version;
    hash = "sha256-LKjZvMXdFVzu3gTbxR6y12ba393ZyHlpIEGmzlYdEv4=";
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
