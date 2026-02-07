{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.rp_filter;
  script = pkgs.writeShellScript "rp_filter.sh" ''
    for i in /proc/sys/net/ipv4/conf/*; do
      echo 0 > $i/rp_filter
    done
  '';
in
{
  options.services.rp_filter = {
    enable = mkEnableOption "Disable rp_filter for all interfaces";
  };
  config = mkIf cfg.enable {
    systemd.services.rp_filter = {
      serviceConfig = {
        ExecStart = "${script}";
      };
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.rp_filter = {
      timerConfig = {
        OnUnitActiveSec = "5m";
        RandomizedDelaySec = "30";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
