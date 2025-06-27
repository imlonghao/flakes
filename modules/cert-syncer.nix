{ config, pkgs, lib, self, ... }:
with lib;
let
  cfg = config.services.cert-syncer;
  shell = pkgs.writeShellScript "cert-syncer.sh" ''
    [ -e /persist/certs ] || mkdir -p /persist/certs
    cd /persist/certs
    for certificateName in ${concatStringsSep " " cfg.wishlist}; do
      if [ -f "$certificateName.raw" ]; then
        sn=$(cat "$certificateName.raw" | ${pkgs.jq}/bin/jq -r .serialNumber)
      else
        sn=na
      fi
      ${pkgs.wget}/bin/wget -O "$certificateName.raw" "https://imlonghao-certimate.val.run/$certificateName"
      new_sn=$(cat "$certificateName.raw" | ${pkgs.jq}/bin/jq -r .serialNumber)
      if [ "x$sn" != "x$new_sn" ]; then
        cat "$certificateName.raw" | ${pkgs.jq}/bin/jq -r .certificate > "$certificateName.crt"
        cat "$certificateName.raw" | ${pkgs.jq}/bin/jq -r .privateKey > "$certificateName.key"
      fi
    done
  '';
in {
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
