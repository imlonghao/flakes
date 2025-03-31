{ buildGoModule, fetchFromGitea, lib }:

buildGoModule rec {
  pname = "supervxlan";
  version = "c983716b2746dff96843f08c43a826a894c5a7a6";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-xcGoK05Y1U55sQb1rq6e6tVRCyJLN3hz5tEePG/Njio=";
  };
  vendorHash = "sha256-fJp906uP6TofwLddhv7jLQCsc1U1PUN53S9pbrPtp0Y=";

  subPackages = [ "cmd/agent" ];

  meta = with lib; {
    description = "A tool for managing VXLAN networks";
    homepage = "https://github.com/imlonghao/supervxlan";
    license = licenses.mit;
  };
}
