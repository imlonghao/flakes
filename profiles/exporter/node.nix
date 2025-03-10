{ config, self, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ]
    config.services.etherguard-edge.ipv4;
in {
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = ip;
    extraFlags = [
      "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|run|var/lib/docker/.+|var/lib/kubelet/.+|root/.+)($|/)"
      "--collector.netclass.ignored-devices=^(docker[0-9]|vboxnet[0-9]|br-.+|veth.+|swan.+)$"
      "--collector.netdev.device-exclude=^(docker[0-9]|vboxnet[0-9]|br-.+|veth.+|swan.+)$"
    ];
  };
  systemd.services."prometheus-node-exporter".after =
    [ "etherguard-edge.service" ];
}

