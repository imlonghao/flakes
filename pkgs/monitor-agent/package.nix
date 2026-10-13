{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "monitor-agent";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "monitor-probe";
    repo = "agent";
    tag = "v${version}";
    hash = "sha256-iR39sVMElyjU2CNc+IaghsaoxFqZGVl7a75NSFaCnQY=";
  };

  cargoHash = "sha256-hj3HCE5bcz71GajbJGqjh0j3w/mq7fw+CutnchbyB2o=";

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
