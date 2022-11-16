{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.tuic;
in
{
  options.services.tuic = {
    enable = mkEnableOption "Delicately-TUICed high-performance proxy built on top of the QUIC protocol";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.tuic = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tuic}/bin/tuic-server -c ${cfg.path}";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
