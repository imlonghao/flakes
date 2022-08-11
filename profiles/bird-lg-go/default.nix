{ config, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ] config.services.etherguard-edge.ipv4;
in
{
  services.bird-lg-go = {
    enable = true;
    listenAddress = "${ip}:8400";
  };
}
