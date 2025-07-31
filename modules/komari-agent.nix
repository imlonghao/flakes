{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.komari-agent;
in
{
  options.services.komari-agent = {
    enable = lib.mkEnableOption "Komari Agent";
    endpoint = lib.mkOption {
      type = lib.types.str;
      description = "API endpoint";
    };
    token = lib.mkOption {
      type = lib.types.str;
      description = "Path to API token";
    };
    month-rotate = lib.mkOption {
      type = lib.types.int;
      description = "Month reset for network statistics";
      default = 0;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.komari-agent = {
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.komari-agent}/bin/komari-agent --disable-auto-update --disable-web-ssh -e ${cfg.endpoint} -t $(cat ${cfg.token}) --month-rotate ${toString cfg.month-rotate}'";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
  };
}
