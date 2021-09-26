{ config, self, ... }:
let
  ip = builtins.replaceStrings [ "/30" ] [ "" ] config.services.gravity.hostAddress;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = ip;
    extraFlags = [
      "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|run|var/lib/docker/.+)($|/)"
      "--collector.netclass.ignored-devices=^veth[a-z0-9]{8}$"
      "--collector.netdev.device-exclude=^veth[a-z0-9]{8}$"
    ];
  };
}

