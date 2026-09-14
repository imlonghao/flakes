{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hysteria2;
in
{
  options.services.hysteria2 = {
    enable = lib.mkEnableOption "Hysteria 2 server";
    configFile = lib.mkOption {
      type = lib.types.str;
      example = "/run/secrets/hysteria2";
      description = ''
        Runtime path to the complete Hysteria 2 server YAML configuration.
        When using sops, set the secret's restartUnits to [ "hysteria2.service" ].
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hysteria2 = {
      description = "Hysteria 2 server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hysteria}/bin/hysteria server --config %d/config.yaml";
        LoadCredential = "config.yaml:${cfg.configFile}";
        Restart = "on-failure";
        RestartSec = "5s";
        DynamicUser = true;
        StateDirectory = "hysteria2";
        WorkingDirectory = "/var/lib/hysteria2";
        Environment = "HOME=/var/lib/hysteria2";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };
  };
}
