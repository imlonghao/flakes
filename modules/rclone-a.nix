{ config, pkgs, lib, ... }:
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
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rclone ];
    systemd.services.rclone-a = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rclone}/bin/rclone mount ${cfg.from} ${cfg.to} --config ${cfg.config}";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      before = cfg.before;
    };
  };
}
