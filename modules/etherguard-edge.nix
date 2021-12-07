{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.etherguard-edge;
in
{
  options.services.etherguard-edge = {
    enable = mkEnableOption "EtherGuard (edge node)";
    path = mkOption {
      type = types.str;
      description = "path to the config file";
    };
    ipv4 = mkOption {
      type = types.str;
      description = "IPv4 address";
    };
    ipv6 = mkOption {
      type = types.str;
      description = "IPv6 address";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.etherguard ];
    systemd.services.etherguard-edge = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.etherguard}/bin/EtherGuard-VPN -mode edge -config ${cfg.path}";
        ExecStartPost = [
          "${pkgs.iproute2}/bin/ip addr add ${cfg.ipv4} dev eg_net"
          "${pkgs.iproute2}/bin/ip addr add ${cfg.ipv6} dev eg_net"
        ];
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
