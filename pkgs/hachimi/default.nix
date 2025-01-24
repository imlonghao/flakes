{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "hachimi";
  version = "7345ef472537feb62cddab7515c1d15f97a674ae";

  src = fetchFromGitHub ({
    owner = "burpheart";
    repo = pname;
    rev = version;
    sha256 = "sha256-Asu7viYl8z6NmWpipUI/Jttidkwz40yInhyaFN7dD2I=";
  });

  vendorHash = "sha256-bEl9RYm2T7DsxQo97aEgUW3GihCaq23StJIOgCcZe54=";

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
