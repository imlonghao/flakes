{ config, ... }:
let
  ip = builtins.replaceStrings [ "/30" ] [ "" ] config.services.gravity.hostAddress;
in
{
  services.prometheus.exporters.bird = {
    enable = true;
    listenAddress = ip;
  };
  systemd.services."prometheus-bird-exporter".after = [ "gravity.service" ];
}
