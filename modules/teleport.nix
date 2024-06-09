{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.myteleport;
  configfile = pkgs.writeText "teleport.json" (builtins.toJSON {
    teleport = {
      nodename = config.networking.hostName;
      data_dir = "/var/lib/teleport";
      pid_file = "/run/teleport.pid";
      auth_token = cfg.teleport.auth_token;
      auth_servers = cfg.teleport.auth_servers;
      connection_limits = {
        max_connections = 15000;
        max_users = 250;
      };
      log = {
        output = "stderr";
        severity = "INFO";
      };
      ca_pin = cfg.teleport.ca_pin;
    };
    ssh_service = {
      enabled = "yes";
      listen_addr = cfg.ssh_service.listen_addr;
      commands = [{
        name = "arch";
        command = [ "${pkgs.coreutils}/bin/uname" "-r" ];
        period = "1h0m0s";
      }];
    };
    auth_service = { enabled = "no"; };
    proxy_service = { enabled = "no"; };
  });
in {
  options.services.myteleport = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    teleport = {
      auth_token = mkOption { type = types.str; };
      auth_servers = mkOption { type = types.listOf types.str; };
      ca_pin = mkOption { type = types.str; };
    };
    ssh_service = {
      listen_addr = mkOption {
        type = types.str;
        default = "0.0.0.0:2222";
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.teleport = {
      enable = true;
      description = "Teleport SSH Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart =
          "${pkgs.teleport}/bin/teleport start --config='${configfile}' --pid-file=/run/teleport.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        PIDFile = "/run/teleport.pid";
      };
    };
  };
}
