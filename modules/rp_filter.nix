{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.rp_filter;
in
{
  options.services.rp_filter = {
    enable = mkEnableOption "Disable rp_filter for all interfaces";
  };
  config = mkIf cfg.enable {
    systemd.services.rp_filter = {
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c 'for i in /proc/sys/net/ipv4/conf/*; do echo 0 > $i/rp_filter; done'";
      };
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.rp_filter = {
      timerConfig = {
        OnCalendar = "5m";
        Unit = "rp_filter.service";
        RandomizedDelaySec = "30";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
