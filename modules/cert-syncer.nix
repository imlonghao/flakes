{
  config,
  pkgs,
  lib,
  self,
  ...
}:
with lib;
let
  cfg = config.services.cert-syncer;
  shell = pkgs.writeShellScript "cert-syncer.sh" ''
    set -euo pipefail

    : "''${ROLE_ID:?Missing OpenBao ROLE_ID}" "''${SECRET_ID:?Missing OpenBao SECRET_ID}"
    if ! BAO_TOKEN=$(
      ${pkgs.jq}/bin/jq -n '{role_id: env.ROLE_ID, secret_id: env.SECRET_ID}' \
        | ${pkgs.openbao}/bin/bao write -format=json auth/approle/login - \
        | ${pkgs.jq}/bin/jq -er '.auth.client_token | select(type == "string" and length > 0)'
    ); then
      echo "Failed to log in to OpenBao; keeping existing files" >&2
      exit 1
    fi
    export BAO_TOKEN
    unset ROLE_ID SECRET_ID

    [ -e /persist/certs ] || mkdir -p /persist/certs
    cd /persist/certs
    updated=false
    for certificateName in ${escapeShellArgs cfg.wishlist}; do
      rawFile="$certificateName.raw"
      rawFileTmp="$rawFile.tmp"
      crtFile="$certificateName.crt"
      crtFileTmp="$crtFile.tmp"
      keyFile="$certificateName.key"
      keyFileTmp="$keyFile.tmp"

      rm -f "$rawFileTmp" "$crtFileTmp" "$keyFileTmp"
      if ! ${pkgs.openbao}/bin/bao kv get -format=json -mount=kv "certs/$certificateName" \
        | ${pkgs.jq}/bin/jq -e '.data.data // .data' > "$rawFileTmp"; then
        echo "Failed to read certificate $certificateName from OpenBao; keeping existing files" >&2
        rm -f "$rawFileTmp"
        continue
      fi

      if ! ${pkgs.jq}/bin/jq -e '
        type == "object"
        and (.crt | type == "string" and length > 0)
        and (.key | type == "string" and length > 0)
      ' "$rawFileTmp" >/dev/null; then
        echo "Downloaded invalid certificate $certificateName; keeping existing files" >&2
        rm -f "$rawFileTmp"
        continue
      fi

      if ! ${pkgs.jq}/bin/jq -r .crt "$rawFileTmp" > "$crtFileTmp" \
        || ! ${pkgs.jq}/bin/jq -r .key "$rawFileTmp" > "$keyFileTmp"; then
        echo "Failed to extract certificate $certificateName; keeping existing files" >&2
        rm -f "$rawFileTmp" "$crtFileTmp" "$keyFileTmp"
        continue
      fi

      if ! ${pkgs.diffutils}/bin/cmp -s "$crtFileTmp" "$crtFile" \
        || ! ${pkgs.diffutils}/bin/cmp -s "$keyFileTmp" "$keyFile"; then
        mv "$crtFileTmp" "$crtFile" || exit 1
        mv "$keyFileTmp" "$keyFile" || exit 1
        updated=true
      else
        rm -f "$crtFileTmp" "$keyFileTmp"
      fi
      mv "$rawFileTmp" "$rawFile"
    done
    unset BAO_TOKEN
    ${optionalString (cfg.postHook != "") ''
      if [ "$updated" = true ]; then
        ${pkgs.writeShellScript "cert-syncer-post-hook" cfg.postHook}
      fi
    ''}
  '';
in
{
  options.services.cert-syncer = {
    enable = mkEnableOption "Download certificates from OpenBao";
    wishlist = mkOption {
      type = types.listOf types.str;
      description = "Certificates to read from kv/certs/<name> in OpenBao (crt and key fields).";
    };
    postHook = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands run once after syncing if at least one certificate was
        updated or its missing files were restored. Runs in /persist/certs.
      '';
      example = ''
        systemctl reload nginx.service
      '';
    };
  };
  config = mkIf cfg.enable {
    sops.secrets.openbao = {
      sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
      restartUnits = [ "cert-syncer.service" ];
    };
    systemd.services.cert-syncer = {
      environment = {
        BAO_ADDR = "https://openbao.esd.cc";
        BAO_NAMESPACE = "imlonghao";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${shell}";
        EnvironmentFile = config.sops.secrets.openbao.path;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.cert-syncer = {
      timerConfig = {
        OnUnitActiveSec = "1d";
        RandomizedDelaySec = "1h";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
