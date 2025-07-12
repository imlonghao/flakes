{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.etherguard-super;
in
{
  options.services.etherguard-super = {
    enable = mkEnableOption "EtherGuard (super node)";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.etherguard ];
    systemd.services.etherguard-super = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.etherguard}/bin/EtherGuard-VPN -mode super -config ${cfg.path}";
        Restart = "always";
        RestartSec = 10;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
