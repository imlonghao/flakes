{ sources, buildGoModule, lib }:

buildGoModule rec {
  inherit (sources.etherguard) pname version src;

  vendorSha256 = "sha256-f3F2xxMvNJ37lxM4VaQwZIhU5g8b3ukCwdpgePhZHPM=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Layer2 version of wireguard with Floyd Warshall implement in go";
    homepage = "https://github.com/KusakabeSi/EtherGuard-VPN";
    license = licenses.mit;
  };
}
