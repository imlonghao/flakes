{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.tuic;
  caps = [ "CAP_NET_BIND_SERVICE" ];
in
{
  options.services.tuic = {
    enable = mkEnableOption "Delicately-TUICed high-performance proxy built on top of the QUIC protocol";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.tuic = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tuic}/bin/tuic-server -c ${cfg.path}";
        User = "tuic";
        Group = "tuic";
        CapabilityBoundingSet = caps;
        AmbientCapabilities = caps;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    users = {
      users.tuic = {
        description = "Delicately-TUICed high-performance proxy user";
        group = "tuic";
        isSystemUser = true;
      };
      groups.tuic = { };
    };
  };
}
