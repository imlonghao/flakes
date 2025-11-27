{
  lib,
  stdenv,
  fetchFromGitHub,
  linuxPackages,
  kernel ? linuxPackages.kernel,
}:

stdenv.mkDerivation rec {
  pname = "lotspeed-${kernel.modDirVersion}";
  version = "4fccc67687fa9e7442831be0ff0f4b08c8c05501";

  src = fetchFromGitHub {
    owner = "uk0";
    repo = "lotspeed";
    rev = version;
    hash = "sha256-OGAzDxB4a1jkbBZ49yRhxEju6Q24enSx+elYRLFWbIM=";
  };

  makeFlags = "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    for x in $(find . -name '*.ko'); do
      cp $x $out/lib/modules/${kernel.modDirVersion}/misc/
    done
  '';

  meta = with lib; {
    description = "LotSpeed TCP congestion control kernel module";
    homepage = "https://github.com/uk0/lotspeed";
    platforms = platforms.linux;
    maintainers = with maintainers; [ imlonghao ];
  };
}
