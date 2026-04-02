{
  buildGoModule,
  fetchFromGitea,
  lib,
}:

buildGoModule rec {
  pname = "supervxlan";
  version = "1c05080913eb681fb09a31878a0539c05e9a75a2";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-neoeeWk0WUxJA66VVR19WW4xmu+zD/BqxieAiiTjZdc=";
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
