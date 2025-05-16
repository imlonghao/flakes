{ buildGoModule, fetchFromGitea, lib }:

buildGoModule rec {
  pname = "supervxlan";
  version = "c75b6e054baef3cd7e626d9c82a736bb61cea1fe";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-m2e41dxOQZDWWQRWj1pZ8GMJnzmmPVNBQ8xw9kt8Clc=";
  };
  vendorHash = "sha256-fJp906uP6TofwLddhv7jLQCsc1U1PUN53S9pbrPtp0Y=";

  subPackages = [ "cmd/agent" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A tool for managing VXLAN networks";
    homepage = "https://github.com/imlonghao/supervxlan";
    license = licenses.mit;
  };
}
