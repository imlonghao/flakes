{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.monitor-agent;
in
{
  options.services.monitor-agent = {
    enable = lib.mkEnableOption "Monitor Agent";
    package = lib.mkPackageOption pkgs "monitor-agent" { };
    endpoint = lib.mkOption {
      type = lib.types.str;
      example = "https://monitor.example.com";
      description = "Monitor hub base URL.";
    };
    token = lib.mkOption {
      type = lib.types.str;
      description = "Path to the node token file, loaded as a systemd credential.";
    };
    interval = lib.mkOption {
      type = lib.types.ints.between 1 3600;
      default = 5;
      description = "Report interval in seconds.";
    };
    include-nics = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "eth0" ];
      description = ''
        Network interfaces for traffic statistics. Empty uses automatic detection.
        Prefix a name with a minus sign to exclude it. Names must match exactly.
      '';
    };
    insecure = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow plaintext WebSocket connections to a remote hub.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.monitor-agent = {
      description = "Monitor Agent";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        MONITOR_SERVER = cfg.endpoint;
        MONITOR_IFACE = lib.concatStringsSep "," cfg.include-nics;
      };
      script = ''
        MONITOR_TOKEN="$(< "$CREDENTIALS_DIRECTORY/token")"
        export MONITOR_TOKEN
        exec ${lib.getExe cfg.package} --interval ${toString cfg.interval} ${lib.optionalString cfg.insecure "--insecure"}
      '';

      serviceConfig = {
        LoadCredential = [ "token:${cfg.token}" ];
        Restart = "always";
        RestartSec = "5s";
        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        # Keep home filesystems visible so their disk usage can be collected.
        ProtectHome = "read-only";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          # getifaddrs uses netlink to enumerate host addresses.
          "AF_NETLINK"
        ];
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
      };
    };
  };
}
