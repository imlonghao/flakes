{ buildGoModule, fetchFromGitea, lib }:

buildGoModule rec {
  pname = "supervxlan";
  version = "3e711925a1789543b8e3078c0e2795dbd45c9ee0";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-K8X+WTl2JWVbkwpR4riDmxMWsURL90vY/k92BibETLo=";
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
