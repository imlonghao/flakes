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
    include-mountpoint = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Semicolon-separated list of mount points to include for disk statistics";
      default = null;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.komari-agent = {
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.komari-agent}/bin/komari-agent --disable-auto-update --disable-web-ssh -e ${cfg.endpoint} -t $(cat ${cfg.token}) --month-rotate ${toString cfg.month-rotate} ${
          lib.optionalString (
            cfg.include-mountpoint != null
          ) " --include-mountpoint \"${cfg.include-mountpoint}\""
        }'";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
