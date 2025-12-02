{
  lib,
  stdenv,
  fetchFromGitHub,
  linuxPackages,
  kernel ? linuxPackages.kernel,
}:

stdenv.mkDerivation rec {
  pname = "lotspeed-${kernel.modDirVersion}";
  version = "b1eaf1cd74152ed1c75615350db917f78b6f84e7"; # zeta-tcp

  src = fetchFromGitHub {
    owner = "uk0";
    repo = "lotspeed";
    rev = version;
    hash = "sha256-5cpQGc2qXKC7yePwKf+EowhU9/hSjv1KazAKSUV0Lhw=";
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
