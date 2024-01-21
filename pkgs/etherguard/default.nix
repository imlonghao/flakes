{ sources, buildGoModule, lib }:

buildGoModule rec {
  pname = "etherguard";
  version = "f622f2a15b91fc54286f3d1f95d59adebab1a4f7";
  src = fetchFromGitHub {
    owner = "KusakabeSi";
    repo = "EtherGuard-VPN";
    rev = "f622f2a15b91fc54286f3d1f95d59adebab1a4f7";
    fetchSubmodules = false;
    sha256 = "sha256-67ocXHf+AN3nyPt4636ZJHGRqWSjkpTiDvU5243urBw=";
  };

  vendorHash = "sha256-9+zpQ/AhprMMfC4Om64GfQLgms6eluTOB6DdnSTNOlk=";

  ldflags = [ "-s" "-w" "-X=main.Version=v0.3.5-${version}" ];

  meta = with lib; {
    description = "Layer2 version of wireguard with Floyd Warshall implement in go";
    homepage = "https://github.com/KusakabeSi/EtherGuard-VPN";
    license = licenses.mit;
  };
}
