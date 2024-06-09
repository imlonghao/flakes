{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.rait;
in {
  options.services.rait = {
    enable = mkEnableOption "R.A.I.T. - Redundant Array of Inexpensive Tunnels";
    path = mkOption {
      type = types.str;
      description = "path to the cron job";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.rait = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = cfg.path;
        Environment = [
          "WGET=${pkgs.wget}/bin/wget"
          "RAIT=${pkgs.rait}/bin/rait"
          "CMP=${pkgs.diffutils}/bin/cmp"
        ];
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.rait = {
      timerConfig = {
        OnBootSec = "30s";
        OnUnitInactiveSec = "5m";
        Unit = "rait.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
