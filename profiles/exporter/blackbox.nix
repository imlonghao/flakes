{ config, pkgs, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ] config.services.etherguard-edge.ipv4;
  # https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md
  blackboxConfig = {
    modules = {
      icmp = {
        prober = "icmp";
        timeout = "5s";
      };
    };
  };
in
{
  services.prometheus.exporters.blackbox = {
    enable = true;
    listenAddress = ip;
    configFile = pkgs.writeText "blackbox.yml" (builtins.toJSON blackboxConfig);
  };
  systemd.services."prometheus-blackbox-exporter".after = [ "etherguard-edge.service" ];
}
