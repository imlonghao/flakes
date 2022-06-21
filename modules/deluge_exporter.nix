{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.deluge_exporter;
in
{
  options.services.deluge_exporter = {
    enable = mkEnableOption "deluge_exporter";
  };
  config = mkIf cfg.enable {
    systemd.services.deluge_exporter = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.deluge_exporter}/bin/deluge_exporter";
        Environment = [
          "DELUGE_CONFIG_DIR=/var/lib/deluge/.config/deluge/"
        ];
        User = "deluge";
        Group = "deluge";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
