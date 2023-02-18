{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption optionalString types;

  cfg = config.services.mybird2;
  caps = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
in
{
  ###### interface
  options = {
    services.mybird2 = {
      enable = mkEnableOption (lib.mdDoc "BIRD Internet Routing Daemon");
      config = mkOption {
        type = types.lines;
        description = lib.mdDoc ''
          BIRD Internet Routing Daemon configuration file.
          <http://bird.network.cz/>
        '';
      };
      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether the config should be checked at build time.
          When the config can't be checked during build time, for example when it includes
          other files, either disable this option or use `preCheckConfig` to create
          the included files before checking.
        '';
      };
      preCheckConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          echo "cost 100;" > include.conf
        '';
        description = lib.mdDoc ''
          Commands to execute before the config file check. The file to be checked will be
          available as `bird2.conf` in the current directory.

          Files created with this option will not be available at service runtime, only during
          build time checking.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mybird ];

    environment.etc."bird/bird2.conf".source = pkgs.writeTextFile {
      name = "bird2";
      text = cfg.config;
      checkPhase = optionalString cfg.checkConfig ''
        ln -s $out bird2.conf
        ${cfg.preCheckConfig}
        ${pkgs.mybird}/bin/bird -d -p -c bird2.conf
      '';
    };

    systemd.services.bird2 = {
      description = "BIRD Internet Routing Daemon";
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ config.environment.etc."bird/bird2.conf".source ];
      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";
        User = "bird2";
        Group = "bird2";
        ExecStart = "${pkgs.mybird}/bin/bird -c /etc/bird/bird2.conf";
        ExecReload = "${pkgs.mybird}/bin/birdc configure";
        ExecStop = "${pkgs.mybird}/bin/birdc down";
        RuntimeDirectory = "bird";
        CapabilityBoundingSet = caps;
        AmbientCapabilities = caps;
        ProtectSystem = "full";
        ProtectHome = "yes";
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        PrivateDevices = true;
        SystemCallFilter = "~@cpu-emulation @debug @keyring @module @mount @obsolete @raw-io";
        MemoryDenyWriteExecute = "yes";
      };
    };
    users = {
      users.bird2 = {
        description = "BIRD Internet Routing Daemon user";
        group = "bird2";
        isSystemUser = true;
      };
      groups.bird2 = { };
    };
  };
}
