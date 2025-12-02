{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.lotspeed;
in
{
  options.services.lotspeed = {
    enable = lib.mkEnableOption "LotSpeed";
    rate = lib.mkOption {
      type = lib.types.int;
      description = "Global physical bandwidth limit";
      default = 125000000;
    };
    start_rate = lib.mkOption {
      type = lib.types.int;
      description = "Soft start initial rate";
      default = 6250000;
    };
    gain = lib.mkOption {
      type = lib.types.int;
      description = "Pacing Gain";
      default = 20;
    };
    beta = lib.mkOption {
      type = lib.types.int;
      description = "Fairness";
      default = 717;
    };
    min_cwnd = lib.mkOption {
      type = lib.types.int;
      description = "Minimum congestion window";
      default = 16;
    };
    max_cwnd = lib.mkOption {
      type = lib.types.int;
      description = "Maximum congestion window";
      default = 15000;
    };
    turbo = lib.mkOption {
      type = lib.types.int;
      description = "Turbo";
      default = 0;
    };
    safe_mode = lib.mkOption {
      type = lib.types.int;
      description = "Safe mode";
      default = 1;
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = [ pkgs.lotspeed ];
      kernelModules = [ "lotspeed" ];
      kernel.sysctl = lib.mkForce {
        "net.ipv4.tcp_congestion_control" = "lotspeed";
        "net.ipv4.tcp_no_metrics_save" = 1;
      };
      extraModprobeConfig = ''
        options lotspeed lotserver_rate=${toString cfg.rate} lotserver_gain=${toString cfg.gain} lotserver_beta=${toString cfg.beta}
        options lotspeed lotserver_min_cwnd=${toString cfg.min_cwnd} lotserver_max_cwnd=${toString cfg.max_cwnd} lotserver_turbo=${toString cfg.turbo}
        options lotspeed lotserver_start_rate=${toString cfg.start_rate} lotserver_safe_mode=${toString cfg.safe_mode}
      '';
    };
  };
}
