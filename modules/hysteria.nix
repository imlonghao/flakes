{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.hysteria;
  caps = [ "CAP_NET_BIND_SERVICE" ];
in {
  options.services.hysteria = {
    enable = mkEnableOption "Hysteria Server Service";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.hysteria = {
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.hysteria}/bin/hysteria server -c ${cfg.path} --disable-update-check";
        User = "hysteria";
        Group = "hysteria";
        CapabilityBoundingSet = caps;
        AmbientCapabilities = caps;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
    users = {
      users.hysteria = {
        description = "Hysteria proxy user";
        group = "hysteria";
        isSystemUser = true;
      };
      groups.hysteria = { };
    };
  };
}
