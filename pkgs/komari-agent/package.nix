{
  lib,
  fetchFromGitHub,
  buildGoModule,
  vnstat,
  makeWrapper,
}:
buildGoModule rec {
  pname = "komari-agent";
  version = "1.0.40";

  src = fetchFromGitHub {
    owner = "komari-monitor";
    repo = pname;
    rev = version;
    hash = "sha256-CAkszhqxjrhc4cyIZQBWGpbuCmcC1fLHUtofmjABnVM=";
  };

  vendorHash = "sha256-Wt2A3rGnY8vpdbWRz9tWBz+PcVxATCjjCwm/YXQz1RY=";

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
