{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "hachimi";
  version = "a82b6daef18d9402739162c078ad98bb3846c6c5";

  src = fetchFromGitHub ({
    owner = "burpheart";
    repo = pname;
    rev = version;
    sha256 = "sha256-7fD11ITCRBB0w75a4kIc/N+m6msOliL3Ke/q1sIOfJE=";
  });

  vendorHash = "sha256-FiiFrXYvpuI623w4+vRJdxy1tTm94wVI/KqhNDYeXsw=";

  subPackages = [ "cmd/honeypot" ];

  postInstall = ''
    install -Dm644 -t $out/share/hachimi/ titles.txt servers.txt
  '';

  meta = {
    description = "A Distributed Honeypot System";
    homepage = "https://github.com/burpheart/hachimi";
    license = lib.licenses.asl20;
  };
}
