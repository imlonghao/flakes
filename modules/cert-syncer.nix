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
    [ -e /persist/certs ] || mkdir -p /persist/certs
    cd /persist/certs
    for certificateName in ${concatStringsSep " " cfg.wishlist}; do
      rawFile="$certificateName.raw"
      rawFileTmp="$rawFile.tmp"
      crtFile="$certificateName.crt"
      crtFileTmp="$crtFile.tmp"
      keyFile="$certificateName.key"
      keyFileTmp="$keyFile.tmp"

      if [ -f "$rawFile" ]; then
        sn=$(${pkgs.jq}/bin/jq -r '.serialNumber // "na"' "$rawFile")
      else
        sn=na
      fi

      rm -f "$rawFileTmp" "$crtFileTmp" "$keyFileTmp"
      if ! ${pkgs.wget}/bin/wget -O "$rawFileTmp" "https://imlonghao-certimate.val.run/$certificateName"; then
        echo "Failed to download certificate $certificateName; keeping existing files" >&2
        rm -f "$rawFileTmp"
        continue
      fi

      if ! ${pkgs.jq}/bin/jq -e '
        type == "object"
        and (.serialNumber | type == "string" and length > 0)
        and (.certificate | type == "string" and length > 0)
        and (.privateKey | type == "string" and length > 0)
      ' "$rawFileTmp" >/dev/null; then
        echo "Downloaded invalid certificate $certificateName; keeping existing files" >&2
        rm -f "$rawFileTmp"
        continue
      fi

      new_sn=$(${pkgs.jq}/bin/jq -r .serialNumber "$rawFileTmp")
      if [ "x$sn" != "x$new_sn" ] || [ ! -s "$crtFile" ] || [ ! -s "$keyFile" ]; then
        if ! ${pkgs.jq}/bin/jq -r .certificate "$rawFileTmp" > "$crtFileTmp" \
          || ! ${pkgs.jq}/bin/jq -r .privateKey "$rawFileTmp" > "$keyFileTmp"; then
          echo "Failed to extract certificate $certificateName; keeping existing files" >&2
          rm -f "$rawFileTmp" "$crtFileTmp" "$keyFileTmp"
          continue
        fi
        mv "$crtFileTmp" "$crtFile"
        mv "$keyFileTmp" "$keyFile"
      fi
      mv "$rawFileTmp" "$rawFile"
    done
  '';
in
{
  options.services.cert-syncer = {
    enable = mkEnableOption "Download certificates from certimate";
    wishlist = mkOption {
      type = types.listOf types.str;
      description = "list of certificates";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.cert-syncer = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${shell}";
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
