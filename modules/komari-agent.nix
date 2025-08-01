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
      type = lib.types.listOf lib.types.str;
      description = "List of mount points to include for disk statistics";
    };
    include-nics = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of network interfaces to include";
      default = [ ];
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.komari-agent = {
      serviceConfig = {
        ExecStart =
          "${pkgs.bash}/bin/bash -c '"
          + "${pkgs.komari-agent}/bin/komari-agent --disable-auto-update --disable-web-ssh"
          + " -e ${cfg.endpoint} -t $(cat ${cfg.token}) --month-rotate ${toString cfg.month-rotate}"
          + " --include-mountpoint \"${lib.strings.concatStringsSep ";" cfg.include-mountpoint}\""
          + (lib.optionalString (
            cfg.include-nics != [ ]
          ) " --include-nics ${lib.strings.concatStringsSep "," cfg.include-nics}")
          + "'";
        Restart = "always";
        DynamicUser = "yes";
        ProtectSystem = "strict";
        ProtectHome = "true";
        PrivateDevices = "true";
        PrivateMounts = "true";
        ProtectKernelTunables = "true";
        ProtectKernelModules = "true";
        ProtectKernelLogs = "true";
        ProtectControlGroups = "true";
        LockPersonality = "true";
        RestrictRealtime = "true";
        ProtectClock = "true";
        MemoryDenyWriteExecute = "true";
        RestrictAddressFamilies = "AF_INET AF_INET6";
        SocketBindDeny = "any";
        CapabilityBoundingSet = "~CAP_BLOCK_SUSPEND CAP_BPF CAP_CHOWN CAP_MKNOD CAP_NET_RAW CAP_PERFMON CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYS_TTY_CONFIG CAP_SYSLOG CAP_WAKE_ALARM";
        SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM @timer:EPERM";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
