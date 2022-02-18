{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.garage;
in
{
  options.services.garage = {
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
        ExecStart = "${pkgs.garage}/bin/garage server -c ${cfg.path}";
        Environment = [
          "RUST_LOG=garage=info"
          "RUST_BACKTRACE=1"
        ];
        StateDirectory = "garage";
        DynamicUser = true;
        ProtectHome = true;
        NoNewPrivileges = true;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
