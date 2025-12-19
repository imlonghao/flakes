{
  lib,
  stdenv,
  fetchFromGitHub,
  linuxPackages,
  kernel ? linuxPackages.kernel,
}:

assert kernel != null;

let
  version = "3ead9ea39231f9d1087a3f651a49edb22c99c5e2"; # zeta-tcp

  mkLotspeed =
    kernel':
    stdenv.mkDerivation rec {
      pname = "lotspeed-${kernel'.modDirVersion}";
      inherit version;

      src = fetchFromGitHub {
        owner = "uk0";
        repo = "lotspeed";
        rev = version;
        hash = "sha256-E4k/aWVsAXzPoKJuxU9OxfoBt01GmHzZdMDrqh1vHY0=";
      };

      nativeBuildInputs = kernel'.moduleBuildDependencies or [ ];

      makeFlags = [
        "KERNEL_DIR=${kernel'.dev}/lib/modules/${kernel'.modDirVersion}/build"
      ];

      installPhase = ''
        mkdir -p $out/lib/modules/${kernel'.modDirVersion}/misc
        for x in $(find . -name '*.ko'); do
          cp "$x" $out/lib/modules/${kernel'.modDirVersion}/misc/
        done
      '';

      meta = with lib; {
        description = "LotSpeed TCP congestion control kernel module";
        homepage = "https://github.com/uk0/lotspeed";
        platforms = platforms.linux;
        maintainers = with maintainers; [ imlonghao ];
      };
    };

  defaultPackage = mkLotspeed kernel;
in
defaultPackage.overrideAttrs (old: {
  passthru = (old.passthru or { }) // {
    forKernel = mkLotspeed;
    forKernelPackages = kernelPackages: mkLotspeed kernelPackages.kernel;
  };
})
