{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.chrony_exporter;
in
{
  options.services.chrony_exporter = {
    enable = mkEnableOption "chrony_exporter";
    listen = mkOption {
      type = types.str;
      description = "listen address";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.chrony_exporter = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.chrony_exporter}/bin/prometheus-chrony-exporter -listen ${cfg.listen}";
        User = config.users.users.chrony.name;
        Group = config.users.users.chrony.group;
        Restart = "always";
        RestartSec = 10;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
