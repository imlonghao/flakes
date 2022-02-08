{ sources, buildGoModule, lib }:

buildGoModule rec {
  inherit (sources.etherguard) pname version src;

  vendorSha256 = "sha256-HdCujCp8xk1TPZkncUtUQiK07WVFP5O4OCIUrtEjlsI";

  ldflags = [ "-s" "-w" "-X=main.Version=v0.3.5-${version}" ];

  meta = with lib; {
    description = "Layer2 version of wireguard with Floyd Warshall implement in go";
    homepage = "https://github.com/KusakabeSi/EtherGuard-VPN";
    license = licenses.mit;
  };
}
