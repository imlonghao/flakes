{ config, self, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ] config.services.etherguard-edge.ipv4;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = ip;
    extraFlags = [
      "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|run|var/lib/docker/.+|var/lib/kubelet/.+)($|/)"
      "--collector.netclass.ignored-devices=^veth[a-z0-9]{8}$"
      "--collector.netdev.device-exclude=^veth[a-z0-9]{8}$"
    ];
  };
  systemd.services."prometheus-node-exporter".after = [ "etherguard-edge.service" ];
}

