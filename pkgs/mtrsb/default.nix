{ sources, buildGoModule, lib, pkgs }:

buildGoModule rec {
  inherit (sources.mtrsb) pname version src vendorSha256;
  propagatedBuildInputs = with pkgs; [
    iputils
  ];
  meta = with lib; {
    description = "MTR.SB Worker";
    license = licenses.mit;
  };
}
