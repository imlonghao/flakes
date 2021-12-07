{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.etherguard-edge;
in
{
  options.services.etherguard-edge = {
    enable = mkEnableOption "EtherGuard (edge node)";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.etherguard ];
    systemd.services.etherguard-edge = {
      serviceConfig = {
        Type = "simple";
        ExecStart = ${pkgs.etherguard}/bin/EtherGuard - mode edge - config ${cfg.path};
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
