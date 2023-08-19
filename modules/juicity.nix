{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.juicity;
in
{
  options.services.juicity = {
    enable = mkEnableOption "a quic-based proxy protocol implementation";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.juicity ];
    systemd.packages = [ pkgs.juicity ];
    systemd.services.juicity-server.environment = {
      QUIC_GO_ENABLE_GSO = true;
    };
  };
}
