{ config, pkgs, ... }:
let
  ip = "100.64.1.${toString config.services.ranet.id}";
in
{
  services.bird-lg.proxy = {
    enable = true;
    listenAddresses = "${ip}:8400";
  };
  systemd.services.bird-lg-proxy = {
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
    };
    after = [
      "supervxlan.service"
      "ranet.service"
    ];
  };
}
