{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.bird-lg-go;
in {
  options.services.bird-lg-go = {
    enable = mkEnableOption "bird looking glass";
    listen = mkOption {
      type = types.str;
      description = "listen address";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.bird-lg-go = {
      serviceConfig = with pkgs; {
        ExecStartPre = "${coreutils}/bin/sleep 10";
        ExecStart =
          "${bird-lg-go}/bin/proxy --listen ${cfg.listen} --bird /run/bird/bird.ctl --traceroute_bin ${traceroute}/bin/traceroute";
        Restart = "on-failure";
        RestartSec = 10;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "supervxlan.service" "ranet.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
