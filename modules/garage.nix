{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.garage;
  prescript = pkgs.writeScript "generate-config" ''
    #!/bin/sh
    cat << EOF > /etc/garage.toml
    metadata_dir = "/var/lib/private/garage/meta"
    data_dir = "/var/lib/private/garage/data"

    replication_mode = "3"

    compression_level = 3

    rpc_bind_addr = "[::]:3901"
    rpc_public_addr = "${cfg.rpc_public_addr}"
    rpc_secret = "$(cat ${cfg.rpc_secret})"

    bootstrap_peers = []

    [s3_api]
    s3_region = "garage"
    api_bind_addr = "[::]:3900"
    root_domain = ".s3.esd.cc"

    [s3_web]
    bind_addr = "[::]:3902"
    root_domain = ".web.esd.cc"
    index = "index.html"
    EOF
    chmod 0400 /etc/garage.toml
  '';
in
{
  options.services.garage = {
    enable = mkEnableOption "Garage Data Store";
    rpc_public_addr = mkOption {
      type = types.str;
      description = "rpc_public_addr";
    };
    rpc_secret = mkOption {
      type = types.str;
      description = "rpc_secret";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      garage
    ];
    systemd.services.garage = {
      serviceConfig = {
        Type = "simple";
        ExecStartPre = [
          "${prescript}"
        ];
        ExecStart = "${pkgs.garage}/bin/garage server";
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
