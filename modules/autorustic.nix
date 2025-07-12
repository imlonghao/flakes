{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.autorustic;
  glob = pkgs.writeText "glob.txt" (lib.concatLines cfg.globs);
  source = lib.concatStringsSep " " cfg.sources;
in
{
  options.services.autorustic = {
    enable = lib.mkEnableOption "autorustic";
    globs = lib.mkOption { type = lib.types.listOf lib.types.str; };
    sources = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.autorustic = {
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = "/run/secrets/rustic";
        ExecStart = "${pkgs.rustic}/bin/rustic backup --cache-dir /persist/rustic --glob-file ${glob} ${source}";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
    systemd.timers.autorustic = {
      timerConfig = {
        OnCalendar = "daily";
        Unit = "autorustic.service";
        Persistent = true;
        RandomizedDelaySec = "3h";
      };
      wantedBy = [ "timers.target" ];
    };
    systemd.services.autorustic-prune = {
      serviceConfig = {
        Type = "exec";
        EnvironmentFile = "/run/secrets/rustic";
        ExecStart = "${pkgs.rustic}/bin/rustic forget --prune --keep-last 3 --keep-daily 13 --keep-weekly 8 --keep-monthly 11";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
    systemd.timers.autorustic-prune = {
      timerConfig = {
        OnCalendar = "weekly";
        Unit = "autorustic-prune.service";
        Persistent = true;
        RandomizedDelaySec = "3h";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
