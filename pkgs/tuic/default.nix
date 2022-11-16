{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tuic";
  version = "0.8.5";

  src =fetchFromGitHub {
    owner = "EAimTY";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-YML4oMJfJoRzN19KJRYA5dzHEpTYmpai59R7h3O3Kd0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = "cp ${./Cargo.lock} Cargo.lock";

  meta = with lib; {
    description = "Delicately-TUICed high-performance proxy built on top of the QUIC protocol";
    homepage = "https://github.com/EAimTY/tuic";
    license = licenses.gpl3Plus;
  };
}
