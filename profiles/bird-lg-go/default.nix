{ config, ... }:
let
  ip = "100.64.1.${toString config.services.ranet.id}";
in {
  services.bird-lg-go = {
    enable = true;
    listen = "${ip}:8400";
  };
}
