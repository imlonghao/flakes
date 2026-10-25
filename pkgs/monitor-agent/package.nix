{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "monitor-agent";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "monitor-probe";
    repo = "agent";
    tag = "v${version}";
    hash = "sha256-W33vLIzg9cYSU1Q08w2oaRTkhKyultj0lNxAlpJqtk8=";
  };

  cargoHash = "sha256-lfm8HeMC0MBU3lRaIVv0XxFsrTEOHcCq4vmg2e6P8X0=";

  # These tests require a real host's network interfaces, filesystem metrics,
  # and virtualization environment, plus external tools such as systemd-detect-virt.
  checkFlags = [
    "--skip=collect::tests::real_host_collection_is_sane"
    "--skip=collect::crosscheck::memory_and_disk_agree_with_free_and_df_on_this_machine"
    "--skip=collect::crosscheck::virtualization_agrees_with_systemd_detect_virt"
  ];

  meta = {
    description = "Linux monitoring agent for the monitor hub";
    homepage = "https://github.com/monitor-probe/agent";
    license = lib.licenses.mit;
    mainProgram = "monitor-agent";
    platforms = lib.platforms.linux;
  };
}
