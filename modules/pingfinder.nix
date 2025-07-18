# SPDX-FileCopyrightText: 2020 Aluísio Augusto Silva Gonçalves <https://aasg.name>
# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.pingfinder;
in
{
  options = {
    services.pingfinder = {
      enable = mkEnableOption "dn42 peer finder client script";

      serviceUrl = mkOption {
        description = "URL of the peer finder service to connect to.";
        default = "https://dn42.us/peers";
        type = types.str;
      };

      uuid = mkOption {
        description = ''
          The identifier of the machine in the peer finder service.
        '';
        type = with types; nullOr str;
        default = null;
      };

      pingsPerRequest = mkOption {
        description = "Number of pings to send for each request.";
        default = 5;
        type = types.ints.positive;
      };

      environmentFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/secrets/pingfinder.env";
      };
    };
  };

  config = {
    systemd.services.pingfinder = mkIf cfg.enable {
      description = "dn42 peer finder client";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = {
        PEERFINDER = cfg.serviceUrl;
        NB_PINGS = toString cfg.pingsPerRequest;
        UUID = mkIf (cfg.uuid != null) cfg.uuid;
        LOGFILE = "/dev/null";
      };
      serviceConfig = {
        Type = "exec";
        Environment = [
          "WARNLOCK=/tmp/pingfinder-warn.lock"
          "LOCKFILE=/tmp/pingfinder-exec.lock"
        ];
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart = "${pkgs.pingfinder}/bin/pingfinder";
        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
      };
    };

    systemd.timers.pingfinder = mkIf cfg.enable {
      wantedBy = [ "timers.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "dn42 peer finder processing timer";
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
      };
    };
  };
}
