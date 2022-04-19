{ sources, buildGo117Module, lib }:

buildGo117Module rec {
  inherit (sources.q-dns) pname version src vendorSha256;

  doCheck = false;

  meta = {
    description = "A tiny command line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
  };
}
