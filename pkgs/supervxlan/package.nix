{
  buildGoModule,
  fetchFromGitea,
  lib,
}:

buildGoModule rec {
  pname = "supervxlan";
  version = "fa165491f6e77a7bb21f49498e1552e9f1d77d83";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-0f9HiOwPbg4o0QEhwfHNhhRj9OcUQTr0RVCzSgQDnbE=";
  };
  vendorHash = "sha256-mhztklDaOsqaVtD2l2uS5AOGLl1sW4YF5/FTuIq2E14=";

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
