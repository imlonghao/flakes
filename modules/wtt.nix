{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.wtt;
in
{
  options.services.wtt = {
    enable = mkEnableOption "WatchTheTraffic";
    listen = mkOption {
      type = types.str;
      description = "listen address";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.wtt = {
      serviceConfig = with pkgs;{
        ExecStart = "${wtt}/bin/monitor --listen ${cfg.listen}:2112";
        WorkingDirectory = "/tmp";
      };
      preStart = "${pkgs.wtt}/bin/generator";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "etherguard-edge.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
