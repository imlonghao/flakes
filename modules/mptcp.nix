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
    boot.kernel.sysctl = { "net.mptcp.checksum_enabled" = 1; };
    systemd.services.mptcp = {
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre =
          "${pkgs.iproute2}/bin/ip mp l add_addr_accepted 8 subflows 8";
        ExecStart = map (x:
          "${pkgs.iproute2}/bin/ip mp e ${x.address} dev ${x.dev} id ${x.id}"
          + (if x.port != null then " port ${x.port}" else "")) cfg.endpoint;
        ExecStop =
          map (x: "${pkgs.iproute2}/bin/ip mp e del id ${x.id}") cfg.endpoint;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
