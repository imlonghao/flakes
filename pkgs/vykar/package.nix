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
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vykar";
    rev = "v${version}";
    hash = "sha256-iEG//jX7CEgPlW5cnCRq8n60V3ASjr/WkGTOXfRK010=";
  };

  cargoHash = "sha256-Z6iqVyMdu7SvY+xm104DGFXWZ6R1inSQGR4i2X8pyyU=";

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
