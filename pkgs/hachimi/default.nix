{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "hachimi";
  version = "b7f16c1c0bde103e4eca4eb7fdae47ca963c20b1";

  src = fetchFromGitHub ({
    owner = "burpheart";
    repo = pname;
    rev = version;
    sha256 = "sha256-E+6/HTKMdTvjnXWDBhPO42Tkfi+udyUuE45vxRLh0NY";
  });

  vendorHash = "sha256-FiiFrXYvpuI623w4+vRJdxy1tTm94wVI/KqhNDYeXsw";

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
