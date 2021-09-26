{ config, self, ... }:
let
  ip = builtins.replaceStrings [ "/30" ] [ "" ] config.services.gravity.hostAddress;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = ip;
  };
}

