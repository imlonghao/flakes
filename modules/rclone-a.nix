{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.rclone-a;
in
{
  options.services.rclone-a = {
    enable = mkEnableOption "Rclone Mount (a)";
    config = mkOption {
      type = types.str;
      description = "path to the config file";
    };
    from = mkOption {
      type = types.str;
      description = "mount from";
    };
    to = mkOption {
      type = types.str;
      description = "mount to";
    };
    before = mkOption {
      type = types.listOf types.str;
      description = "run before what services";
    };
    cacheSize = mkOption {
      type = types.str;
      description = "cacheSize";
      default = "5G";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rclone ];
    systemd.services.rclone-a = {
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone cmount ${cfg.from} ${cfg.to} \
          --config ${cfg.config} --allow-other --dir-cache-time 5000h \
          --poll-interval 10s --umask 002 --user-agent BlessingSoftware \
          --cache-dir=/persist/cache/rclone-a --drive-pacer-min-sleep 10ms \
          --drive-pacer-burst 200 --vfs-cache-mode full \
          --vfs-cache-max-size ${cfg.cacheSize} --vfs-cache-max-age 5000h \
          --vfs-cache-poll-interval 5m --vfs-read-ahead 2G --bwlimit-file 32M
        '';
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      before = cfg.before;
    };
  };
}
