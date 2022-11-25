{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.mygarage;
in
{
  options.services.mygarage = {
    enable = mkEnableOption "Garage Data Store";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      garage
    ];
    systemd.services.garage = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.garage}/bin/garage -c ${cfg.path} server";
        Environment = [
          "RUST_LOG=garage=info"
          "RUST_BACKTRACE=1"
        ];
        StateDirectory = "garage";
        ProtectHome = true;
        NoNewPrivileges = true;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
