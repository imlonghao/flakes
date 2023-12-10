{ sources, buildGo119Module, lib }:

buildGo119Module rec {
  inherit (sources.q-dns) pname version src;

  vendorHash = "sha256-cZRaf5Ks6Y4PzeVN0Lf1TxXzrifb7uQzsMbZf6JbLK4=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  doCheck = false;

  meta = {
    description = "A tiny command line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
  };
}
