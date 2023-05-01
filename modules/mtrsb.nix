{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.mtrsb;
in
{
  options.services.mtrsb = {
    enable = mkEnableOption "MTR.SB Worker";
  };
  config = mkIf cfg.enable {
    systemd.services.mtrsb = {
      serviceConfig = with pkgs;{
        ExecStart = "${mtrsb}/bin/worker";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
