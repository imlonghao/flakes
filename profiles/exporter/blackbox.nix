{ config, pkgs, ... }:
let
  ip = "100.64.1.${toString config.services.ranet.id}";
  # https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md
  blackboxConfig = {
    modules = {
      icmp = {
        prober = "icmp";
        timeout = "5s";
      };
    };
  };
in {
  services.prometheus.exporters.blackbox = {
    enable = true;
    listenAddress = ip;
    configFile = pkgs.writeText "blackbox.yml" (builtins.toJSON blackboxConfig);
  };
  systemd.services."prometheus-blackbox-exporter".after =
    [ "ranet.service" ];
}
