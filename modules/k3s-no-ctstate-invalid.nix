{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.k3s-no-ctstate-invalid;
in
{
  options.services.k3s-no-ctstate-invalid = {
    enable = mkEnableOption "Automatic delete k3s generated iptables rule";
  };
  config = mkIf cfg.enable {
    systemd.services.k3s-no-ctstate-invalid = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.iptables}/bin/iptables -w -L FORWARD 1 | ${pkgs.gnugrep}/bin/fgrep \"ctstate INVALID\" || ${pkgs.iptables}/bin/iptables -w -I FORWARD -m conntrack --ctstate INVALID -j ACCEPT'";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.k3s-no-ctstate-invalid = {
      timerConfig = {
        OnBootSec = "5min";
        OnUnitInactiveSec = "1h";
        Unit = "k3s-no-ctstate-invalid.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
