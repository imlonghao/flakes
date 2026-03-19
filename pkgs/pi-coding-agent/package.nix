{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.60.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${finalAttrs.version}.tgz";
    hash = "sha256-G7xWVmnXcu7VhrN5fCkyd1SGGH00+mvPWVpcgJnUiAM=";
  };

  npmDepsHash = "sha256-qiK0vCqeutRVuoarBrMs+8z1HgWKPzcxtcJbCWWNQBU=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgram = "${placeholder "out"}/bin/pi";
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://shittycodingagent.ai/";
    downloadPage = "https://www.npmjs.com/package/@mariozechner/pi-coding-agent";
    changelog = "https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "pi";
  };
})
