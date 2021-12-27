# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  babeld = {
    pname = "babeld";
    version = "44b3135897726d7155e54ac079ce2a7f911b0c44";
    src = fetchFromGitHub ({
      owner = "imlonghao";
      repo = "babeld";
      rev = "44b3135897726d7155e54ac079ce2a7f911b0c44";
      fetchSubmodules = true;
      sha256 = "11wh3w4iilc7a3b2x98kb7ba2hhhy2k5za3h6c4yiwvsx0hca7ib";
    });
  };
  etherguard = {
    pname = "etherguard";
    version = "3a1fad03664f9f90fd461192c816f2fe85277528";
    src = fetchFromGitHub ({
      owner = "KusakabeSi";
      repo = "EtherGuard-VPN";
      rev = "3a1fad03664f9f90fd461192c816f2fe85277528";
      fetchSubmodules = false;
      sha256 = "0jlmm6nxj0cszah1pdg7rr4gbgai1ci4xip4jkmd01ddiz078y50";
    });
  };
  manix = {
    pname = "manix";
    version = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
    src = fetchFromGitHub ({
      owner = "mlvzk";
      repo = "manix";
      rev = "d08e7ca185445b929f097f8bfb1243a8ef3e10e4";
      fetchSubmodules = false;
      sha256 = "1b7xi8c2drbwzfz70czddc4j33s7g1alirv12dwl91hbqxifx8qs";
    });
  };
  rait = {
    pname = "rait";
    version = "19076c4a9e52c75c5b5a259f3b47bc3ef703eeb4";
    src = fetchgit {
      url = "https://gitlab.com/NickCao/RAIT";
      rev = "19076c4a9e52c75c5b5a259f3b47bc3ef703eeb4";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "020gz8z4sn60kv9jasq682s8abmdlz841fwvf7zc86ksb79z4m99";
    };
    vendorSha256 = "sha256-55Zu1g+pwTt6dU1QloxfFkG2dbnK5gg84WvRhz2ND3M=";
  };
}
