{ config, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ] config.services.etherguard-edge.ipv4;
in
{
  services.bird-lg-go = {
    enable = true;
    listen = "${ip}:8400";
  };
}
