{ buildGoModule, fetchFromGitea, lib }:

buildGoModule rec {
  pname = "coredns-nat64-rdns";
  version = "1.0.0";
  src = fetchFromGitea {
    domain = "git.esd.cc";
    owner = "imlonghao";
    repo = pname;
    rev = version;
    hash = "sha256-PAlkfsVAdPmKdCBhzIBYsRm5xqNvRsJlzj/t9psVeiY=";
  };
  vendorHash = "sha256-ZrKcJZHknBgkesXMwWA+FotGXdtkZoDF8wURSZcdeGQ=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/coredns
  '';

  meta = with lib; {
    description = "A CoreDNS plugin handling rDNS for NAT64 address";
    homepage = "https://github.com/imlonghao/coredns-nat64-rdns";
    license = licenses.mit;
  };
}
