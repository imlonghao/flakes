{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.autorestic;
in {
  options.services.autorestic = {
    enable = mkEnableOption "autorestic";
    settings = mkOption {
      type =
        types.submodule { freeformType = with lib.types; attrsOf anything; };
    };
  };
  config = mkIf cfg.enable {
    environment.etc."autorestic.yml".text = builtins.toJSON cfg.settings;
    systemd.services.autorestic = {
      serviceConfig = {
        Type = "exec";
        EnvironmentFile = "/run/secrets/autorestic";
        ExecStart =
          "${pkgs.autorestic}/bin/autorestic -c /etc/autorestic.yml --restic-bin ${pkgs.restic}/bin/restic --ci cron";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.autorestic = {
      timerConfig = {
        OnBootSec = "5m";
        OnUnitInactiveSec = "5m";
        Unit = "autorestic.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
