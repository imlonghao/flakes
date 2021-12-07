{ sources, buildGoModule, lib }:

buildGoModule rec {
  inherit (sources.etherguard) pname version src;

  vendorSha256 = "sha256-X/oOun+t281SFIc6WBQ4ARHZHvnHssq45yDjIYP8MYA=";

  meta = with lib; {
    description = "Layer2 version of wireguard with Floyd Warshall implement in go";
    homepage = "https://github.com/KusakabeSi/EtherGuard-VPN";
    license = licenses.mit;
  };
}
