{
  fetchgit,
  buildGoModule,
  lib,
  pkgs,
}:

buildGoModule rec {
  pname = "wtt";
  version = "30a23dd940cc4351d2f09dd6bbb5f1a51675d2bb";
  src = fetchgit {
    url = "https://git.esd.cc/imlonghao/WatchTheTraffic";
    rev = "30a23dd940cc4351d2f09dd6bbb5f1a51675d2bb";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-2gbZ1eX6MV1PlrkifQObz030Qubxw9F6rS+CnjKTpok=";
  };
  vendorHash = "sha256-9ZR+qTCz5b+7wEQDlmniQmfiHhcdt36tmLv/7VYzcLA=";
  buildInputs = [ pkgs.libpcap ];
  meta = with lib; {
    description = "traffic monitor";
    homepage = "prev.callPackage ./";
    license = licenses.mit;
  };
}
