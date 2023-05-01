{ sources, buildGoModule, lib, pkgs, makeWrapper }:

buildGoModule rec {
  inherit (sources.mtrsb) pname version src vendorSha256;
  subPackages = [ "cmd/worker" ];
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/worker --suffix PATH : ${lib.makeBinPath [ pkgs.iputils ]}
  '';
  meta = with lib; {
    description = "MTR.SB Worker";
    license = licenses.mit;
  };
}