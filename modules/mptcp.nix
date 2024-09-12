{ config, pkgs, lib, ... }:
with lib;
let cfg = config.mptcp;
in {
  options.mptcp = {
    enable = mkEnableOption "mptcp server";
    endpoint = mkOption {
      type = types.listOf (types.submodule ({
        options.address = mkOption { type = types.str; };
        options.dev = mkOption { type = types.str; };
        options.id = mkOption { type = types.int; };
        options.port = mkOption {
          type = types.nullOr types.port;
          default = null;
        };
      }));
    };
  };
  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.mptcp.checksum_enabled" = 1;
      "net.ipv4.ip_nonlocal_bind" = 1;
    };
    networking.interfaces = lib.listToAttrs (map (x:
      lib.nameValuePair "lo" {
        ipv4.addresses = [{
          address = "${x.address}";
          prefixLength = 32;
        }];
      }) (builtins.filter (x: x.port != null) cfg.endpoint));
    systemd.services.mptcp = {
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "30s";
        ExecStartPre =
          "${pkgs.iproute2}/bin/ip mptcp limits set add_addr_accepted 8 subflows 8";
        ExecStart = builtins.concatLists [
          (map (x:
            ("${pkgs.iproute2}/bin/ip mptcp endpoint add ${x.address} signal dev ${x.dev} id ${
                toString x.id
              }" + (if x.port != null then " port ${toString x.port}" else "")))
            cfg.endpoint)
          (builtins.concatLists (map (x: [
            "${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport ${
              toString x.port
            } -j DNAT --to-destination ${x.address}"
            "${pkgs.iproute2}/bin/ip route add local ${x.address} dev lo table ${
              toString (1000 + x.id)
            }"
            "${pkgs.iproute2}/bin/ip rule add dport ${toString x.port} table ${
              toString (1000 + x.id)
            }"
            "-${pkgs.iproute2}/bin/ip route delete local ${x.address} dev lo"
          ]) (builtins.filter (x: x.port != null) cfg.endpoint)))
        ];
        ExecStopPost = builtins.concatLists [
          [ "${pkgs.iproute2}/bin/ip mptcp endpoint flush" ]
          (builtins.concatLists (map (x: [
            "-${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport ${
              toString x.port
            } -j DNAT --to-destination ${x.address}"
            "${pkgs.iproute2}/bin/ip route flush table ${
              toString (1000 + x.id)
            }"
            "-${pkgs.iproute2}/bin/ip rule delete dport ${
              toString x.port
            } table ${toString (1000 + x.id)}"
            "-${pkgs.iproute2}/bin/ip route add local ${x.address} dev lo"
          ]) (builtins.filter (x: x.port != null) cfg.endpoint)))
        ];
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
