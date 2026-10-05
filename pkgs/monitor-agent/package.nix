{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "monitor-agent";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "monitor-probe";
    repo = "agent";
    tag = "v${version}";
    hash = "sha256-tqJpvFmq7TvdvusUXSF689tln+rXfZwFUKn9s1ixFIs=";
  };

  cargoHash = "sha256-TAbrvHrN7k4rKA0DENtbYvwrGeNCWgf5ppFxeFr5WK4=";

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
