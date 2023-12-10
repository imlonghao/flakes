{ sources, buildGoModule, lib, pkgs }:

buildGoModule rec {
  inherit (sources.wtt) pname version src vendorHash;
  buildInputs = [ pkgs.libpcap ];
  meta = with lib; {
    description = "traffic monitor";
    homepage = "prev.callPackage ./";
    license = licenses.mit;
  };
}
