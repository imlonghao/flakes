{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.rait;
  cronJob = pkgs.writeScript "rait.sh" ''
    #!/bin/sh
    set -e

    ${pkgs.wget}/bin/wget -q -O /tmp/rait.new ${cfg.registry}

    if [ ! -f /tmp/rait.old ]; then
      ${pkgs.rait}/bin/rait u
      mv /tmp/rait.new /tmp/rait.old
      exit 0
    fi

    cmp -s /tmp/rait.old /tmp/rait.new || (sleep $[ ( $RANDOM % 180 ) + 1 ]s && ${pkgs.rait}/bin/rait u && mv /tmp/rait.new /tmp/rait.old)
  '';
  configFile = pkgs.writeText "rait.conf" ''
    registry     = "${cfg.registry}" # url of rait registry
    operator_key = "${cfg.operator_key}" # private key of node operator
    private_key  = "${cfg.private_key}" # wireguard private key

    namespace    = "rait" # netns to move interfaces into

    # both ifgroup and ifprefix should be unique across transports
    transport {
      address_family = "ip4"
      address        = "${cfg.ip}"
      send_port      = ${builtins.toString cfg.port}
      mtu            = 1400
      ifprefix       = "rait4x"
      ifgroup        = 54
      fwmark         = 54
      random_port    = false
    }

    babeld {
      enabled     = true
      socket_type = "unix"
      socket_addr = "/run/babeld.ctl"
      param       = "type tunnel link-quality true split-horizon false rxcost 32 hello-interval 20 max-rtt-penalty 1024 rtt-max 1024"
      footnote    = "interface host type wired"
    }

    remarks = {
      hostname = "${networking.hostname}"
    }
  '';
in
{
  options.services.rait = {
    enable = mkEnableOption "R.A.I.T. - Redundant Array of Inexpensive Tunnels";
    registry = mkOption {
      type = types.str;
      description = "url of rait registry";
    };
    operator_key = mkOption {
      type = types.str;
      description = "private key of node operator";
    };
    private_key = mkOption {
      type = types.str;
      description = "wireguard private key";
    };
    ip = mkOption {
      type = types.str;
      description = "ip";
    };
    port = mkOption {
      type = types.int;
      description = "port";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.rait = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = cronJob;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.rait = {
      timerConfig = {
        OnBootSec = "30s";
        OnUnitInactiveSec = "5m";
        Unit = "rait.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
