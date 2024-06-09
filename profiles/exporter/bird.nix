{ config, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ]
    config.services.etherguard-edge.ipv4;
in {
  services.prometheus.exporters.bird = {
    enable = true;
    listenAddress = ip;
  };
  systemd.services."prometheus-bird-exporter".after =
    [ "etherguard-edge.service" ];
}
