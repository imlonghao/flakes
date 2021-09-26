{ config, ... }:
let
  ip = builtins.replaceStrings [ "/30" ] [ "" ] config.services.gravity.hostAddress;
in
{
  services.prometheus.exporters.bird = {
    enable = true;
    listenAddress = ip;
  };
}
