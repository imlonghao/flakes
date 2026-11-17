{
  lib,
  fetchFromGitHub,
  buildGo127Module,
}:
buildGo127Module rec {
  pname = "hikyaku";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SukkaW";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-sn5swcFIhYmA0wwaOmCBX5k7KuYIYnPtk5mGIM6gZ+M=";
  };

  vendorHash = "sha256-YcUm+Wnd5ZH0zFqGhX0OEzps8dU0XjJsv0UNr2tNwzE=";

  subPackages = [
    "cmd/hikyaku-client"
    "cmd/hikyaku-server"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "High-performance multiplexing proxy for fast and reliable connections";
    homepage = "https://github.com/SukkaW/hikyaku";
    changelog = "https://github.com/SukkaW/hikyaku/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "hikyaku-client";
  };
}
