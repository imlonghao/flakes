# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  babeld = {
    pname = "babeld";
    version = "44b3135897726d7155e54ac079ce2a7f911b0c44";
    src = fetchFromGitHub {
      owner = "imlonghao";
      repo = "babeld";
      rev = "44b3135897726d7155e54ac079ce2a7f911b0c44";
      fetchSubmodules = true;
      sha256 = "sha256-Kx7FIOh68+gJM3CoX6bwEEKh1lkTpS7WUIfRGAkfkIc=";
    };
    date = "2021-06-08";
  };
  chrony_exporter = {
    pname = "chrony_exporter";
    version = "796d32a9a4f686a15e61c58217962a2ec931db5b";
    src = fetchgit {
      url = "https://git.esd.cc/imlonghao/prometheus-chrony-exporter";
      rev = "796d32a9a4f686a15e61c58217962a2ec931db5b";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-fi7Ikp1TRuZ+0svh8jTngFBKoIBUMOKuwNdT9KvZi6o=";
    };
    date = "2023-07-15";
  };
  deluge_exporter = {
    pname = "deluge_exporter";
    version = "c8a31ede70133498b49b6ac4a1a63b57292e7b47";
    src = fetchFromGitHub {
      owner = "tobbez";
      repo = "deluge_exporter";
      rev = "c8a31ede70133498b49b6ac4a1a63b57292e7b47";
      fetchSubmodules = false;
      sha256 = "sha256-Yz85DhN3g4YPP+aBX49jLCLDJfgUSAQJgowh0smVVgQ=";
    };
    date = "2023-01-24";
  };
  etherguard = {
    pname = "etherguard";
    version = "7775441e24d68b191fd285d851e58713bead8bc5";
    src = fetchFromGitHub {
      owner = "KusakabeSi";
      repo = "EtherGuard-VPN";
      rev = "7775441e24d68b191fd285d851e58713bead8bc5";
      fetchSubmodules = false;
      sha256 = "sha256-KOJAD0IUE7HIrCbCg4RuERiyaasz7o053sEL+ZurdVQ=";
    };
    date = "2023-02-23";
  };
  manix = {
    pname = "manix";
    version = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
    src = fetchFromGitHub {
      owner = "mlvzk";
      repo = "manix";
      rev = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
      fetchSubmodules = false;
      sha256 = "sha256-GqPuYscLhkR5E2HnSFV4R48hCWvtM3C++3zlJhiK/aw=";
    };
    date = "2021-04-20";
  };
  mtrsb = {
    pname = "mtrsb";
    version = "adb018d24c62c3e093cf26ab51d1e67f5e01436f";
    src = fetchgit {
      url = "https://git.esd.cc/imlonghao/mtr.sb";
      rev = "adb018d24c62c3e093cf26ab51d1e67f5e01436f";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-lhGqnTCXvfnhMzbPDVbiA+TxAOeqvdITrU6Cr/HGn8c=";
    };
    vendorSha256 = "sha256-UC+if91e2MyNYnZXYUumI3F4frHDScxuPEAg9RBVJW4=";
    date = "2023-07-14";
  };
  mybird = {
    pname = "mybird";
    version = "901f906ac470b318d6598c8b25156b0919f70b2a";
    src = fetchFromGitHub {
      owner = "tohojo";
      repo = "bird";
      rev = "901f906ac470b318d6598c8b25156b0919f70b2a";
      fetchSubmodules = false;
      sha256 = "sha256-PhRmXPTD2cidDwWkKkpVrdGWNr5kEuCZz1B74VXX0BQ=";
    };
    date = "2023-02-26";
  };
  q-dns = {
    pname = "q-dns";
    version = "v0.11.4";
    src = fetchFromGitHub {
      owner = "natesales";
      repo = "q";
      rev = "v0.11.4";
      fetchSubmodules = false;
      sha256 = "sha256-zoIHpj1i0X5SCVhcT3bl5xxsDcvD2trEVhlIC5YnIZo=";
    };
  };
  rait = {
    pname = "rait";
    version = "278188c8bae13165aa70b6a2fbbb99101fd6f4cd";
    src = fetchgit {
      url = "https://gitlab.com/NickCao/RAIT";
      rev = "278188c8bae13165aa70b6a2fbbb99101fd6f4cd";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-6Y0s5/HUmWrZA6QmV5wYjB1M0Ab/jHM3TSruRpMRwtA=";
    };
    vendorSha256 = "sha256-T/ufC4mEXRBKgsmIk8jSCQva5Td0rnFHx3UIVV+t08k=";
    date = "2022-10-07";
  };
  wesher = {
    pname = "wesher";
    version = "c681651656af222561ab35c2a17b321503a28616";
    src = fetchFromGitHub {
      owner = "costela";
      repo = "wesher";
      rev = "c681651656af222561ab35c2a17b321503a28616";
      fetchSubmodules = false;
      sha256 = "sha256-mI/DisH4F2+0nYfzJjspQlnfrAqswH4vVuW1m/sw23c=";
    };
    vendorSha256 = "sha256-QoIwp475/+QDYY65TG4DaFH5wbM5eQGREuIJCbBLFy0=";
    date = "2023-06-26";
  };
  wtt = {
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
    vendorSha256 = "sha256-9ZR+qTCz5b+7wEQDlmniQmfiHhcdt36tmLv/7VYzcLA=";
    date = "2023-03-19";
  };
}
