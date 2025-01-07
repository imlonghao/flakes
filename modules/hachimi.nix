{ config, pkgs, lib, ... }:
let cfg = config.services.hachimi;
in {
  options.services.hachimi = {
    enable = lib.mkEnableOption "Hachimi Honeypot";
    path = lib.mkOption {
      type = lib.types.str;
      description = "path to the config file";
    };
    postStart = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "additional commands to run after startup";
      default = [ ];
    };
    postStop = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "additional commands to run after shutdown";
      default = [ ];
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.hachimi = {
      serviceConfig = {
        WorkingDirectory = "${pkgs.hachimi}/share/hachimi";
        ExecStart = "${pkgs.hachimi}/bin/honeypo -configPath ${cfg.path}";
        ExecStartPost = cfg.postStart;
        ExecStopPost = cfg.postStop;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}