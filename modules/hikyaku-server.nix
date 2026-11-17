{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hikyaku-server;
  listenAddress =
    if lib.hasInfix ":" cfg.listenAddress then "[${cfg.listenAddress}]" else cfg.listenAddress;
  args = [
    "-listen"
    "${listenAddress}:${toString cfg.listenPort}"
  ]
  ++ lib.concatMap (server: [
    "-dns"
    server
  ]) cfg.dns;
in
{
  options.services.hikyaku-server = {
    enable = lib.mkEnableOption "Hikyaku server";

    package = lib.mkPackageOption pkgs "hikyaku" { };

    pskFile = lib.mkOption {
      type = lib.types.str;
      example = "/run/secrets/hikyaku-psk";
      description = ''
        Runtime path to a file containing the pre-shared key, loaded as a
        systemd credential. Trailing newlines are stripped. The key is kept
        out of the Nix store, but upstream requires passing it in the process
        arguments, where it may be visible to other local users.
        When using sops, set the secret's restartUnits to [ "hikyaku-server.service" ].
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "::1";
      description = "Address to listen on, without IPv6 brackets. Empty listens on all interfaces.";
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 8444;
      description = "TCP port on which the server listens for client connections.";
    };

    dns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "https://1.1.1.1/dns-query"
        "tls://8.8.8.8"
      ];
      description = ''
        DNS servers for destinations. Each entry may be an IP address or a
        udp://, tcp://, tls://, https://, quic://, h3:// or sdns:// address.
        Empty uses the system resolver.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the server's TCP listen port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.listenPort ];

    systemd.services.hikyaku-server = {
      description = "Hikyaku server";
      documentation = [ "https://github.com/SukkaW/hikyaku" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        psk="$(< "$CREDENTIALS_DIRECTORY/psk")"
        if [[ -z "$psk" ]]; then
          echo "Hikyaku pre-shared key must not be empty" >&2
          exit 1
        fi
        exec ${lib.getExe' cfg.package "hikyaku-server"} ${lib.escapeShellArgs args} -psk "$psk"
      '';

      serviceConfig = {
        LoadCredential = [ "psk:${cfg.pskFile}" ];
        Restart = "on-failure";
        RestartSec = "5s";
        TimeoutStopSec = "15s";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        # BBR must be the system default or in tcp_allowed_congestion_control
        # to be usable without granting the service CAP_NET_ADMIN.
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}
