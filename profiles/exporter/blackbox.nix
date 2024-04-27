{ config, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ] config.services.etherguard-edge.ipv4;
in
{
  services.prometheus.exporters.blackbox = {
    enable = true;
    listenAddress = ip;
  };
  systemd.services."prometheus-blackbox-exporter".after = [ "etherguard-edge.service" ];
}
