{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.peerfinder-agent;
in
{
  options.services.peerfinder-agent = {
    enable = lib.mkEnableOption "dn42 Peer Finder measurement agent";

    package = lib.mkPackageOption pkgs "peerfinder-agent" { };

    secretKeyFile = lib.mkOption {
      type = lib.types.str;
      example = "/run/secrets/peerfinder-agent";
      description = ''
        Path to a file containing the 32-byte HMAC secret key as a hexadecimal
        string. The file is passed to the service as a systemd credential.
      '';
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "TCP port on which the agent listens for measurement requests.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "DEBUG"
        "INFO"
        "WARNING"
        "ERROR"
        "CRITICAL"
      ];
      default = "INFO";
      description = "Logging verbosity of the agent.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the agent's TCP listen port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.listenPort ];

    systemd.services.peerfinder-agent = {
      description = "DN42 Peer Finder Measurement Agent";
      documentation = [ "https://peerfinder.dn42.dev" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        SECRET_KEY_FILE = "%d/secret-key";
        LISTEN_PORT = toString cfg.listenPort;
        LOG_LEVEL = cfg.logLevel;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        RestartSec = "300s";
        LoadCredential = [ "secret-key:${cfg.secretKeyFile}" ];

        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        AmbientCapabilities = [ "CAP_NET_RAW" ];
        CapabilityBoundingSet = [ "CAP_NET_RAW" ];
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        TasksMax = 20;
      };
    };
  };
}
