{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "monitor-agent";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "monitor-probe";
    repo = "agent";
    tag = "v${version}";
    hash = "sha256-b3lMMkFrY8BSlSMPO4WAADEMMaMumoclAtxiZdmJeYw=";
  };

  cargoHash = "sha256-jqoS4Sk0r+vOUjoHSF2eFFH9ksKfHqMYYk7+yjJxj3Q=";

  # These tests require a real host's network interfaces and filesystem metrics.
  checkFlags = [
    "--skip=collect::tests::real_host_collection_is_sane"
    "--skip=collect::crosscheck::memory_and_disk_agree_with_free_and_df_on_this_machine"
  ];

  meta = {
    description = "Linux monitoring agent for the monitor hub";
    homepage = "https://github.com/monitor-probe/agent";
    license = lib.licenses.mit;
    mainProgram = "monitor-agent";
    platforms = lib.platforms.linux;
  };
}
