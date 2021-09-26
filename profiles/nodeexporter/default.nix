{ config, self, ... }:
let
  ip = builtins.replaceStrings [ "/30" ] [ "" ] config.services.gravity.hostAddress;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = ip;
    extraFlags = [
      "--collector.netdev.device-exclude=COLLECTOR.NETDEV.DEVICE-EXCLUDE=^veth[a-z0-9]{8}$"
    ];
  };
}

