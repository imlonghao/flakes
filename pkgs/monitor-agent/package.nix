{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "monitor-agent";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "monitor-probe";
    repo = "agent";
    tag = "v${version}";
    hash = "sha256-gpBxLnZNveMi9tnYx4dstF1wjfH7aCER7U8GaTsfsa4=";
  };

  cargoHash = "sha256-4jLXINDOUiS1QyugtyKYBOiBVCk952G5scYK1d7G6Ys=";

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
