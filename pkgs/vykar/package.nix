{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "vykar";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vykar";
    rev = "v${version}";
    hash = "sha256-WMIVeh9JNjzjiXGuGo9Ok3r6sV5X2bWrDf2GfJoMFPk=";
  };

  cargoHash = "sha256-Dplp+ro1e0rAMQlurxZhMi7YGYE5itqnT7SqfgXYv0M=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # Build only CLI and server, exclude GUI
  cargoBuildFlags = [
    "--package"
    "vykar-cli"
    "--package"
    "vykar-server"
  ];

  # Disable tests as they may require network or specific setup
  doCheck = false;

  meta = with lib; {
    description = "A fast, encrypted, deduplicated backup tool written in Rust";
    homepage = "https://github.com/borgbase/vykar";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "vykar";
  };
}
