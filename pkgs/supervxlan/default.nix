{ buildGoModule, fetchFromGitea, lib }:

buildGoModule rec {
  pname = "supervxlan";
  version = "2473403d3d38ff59b723b62e62880fc161871e7a";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-aPKiTIeXL1WNtMnPGxZPTbdGfhtdrLSJLy3AXGph90s=";
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
