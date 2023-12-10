{ sources, buildGoModule, lib }:

buildGoModule rec {
  inherit (sources.etherguard) pname version src;

  vendorHash = "sha256-9+zpQ/AhprMMfC4Om64GfQLgms6eluTOB6DdnSTNOlk=";

  ldflags = [ "-s" "-w" "-X=main.Version=v0.3.5-${version}" ];

  meta = with lib; {
    description = "Layer2 version of wireguard with Floyd Warshall implement in go";
    homepage = "https://github.com/KusakabeSi/EtherGuard-VPN";
    license = licenses.mit;
  };
}
