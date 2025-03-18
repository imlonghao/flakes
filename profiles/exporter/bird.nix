{ config, ... }:
let
  ip = "100.64.1.${toString config.services.ranet.id}";
in {
  services.prometheus.exporters.bird = {
    enable = true;
    listenAddress = ip;
  };
  systemd.services."prometheus-bird-exporter".after =
    [ "ranet.service" ];
}
