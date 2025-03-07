{ config, pkgs, lib, ... }:
with lib;
let cfg = config.wrap;
in {
  options.wrap = {
    enable = mkEnableOption "Cloudflare Wrap Tunnel";
    ip = mkOption { type = types.str; };
    path = mkOption { type = types.path; };
  };
  config = mkIf cfg.enable {
    networking.wireguard.interfaces.wrap = {
      table = "913335";
      privateKeyFile = cfg.path;
      ips = [ "172.16.0.2/32" "${cfg.ip}" ];
      mtu = 1420;
      postSetup = [
        "${pkgs.iproute2}/bin/ip rule add from 10.133.35.0/24 table 913335"
        "${pkgs.iproute2}/bin/ip -6 rule add from 133:35::/64 table 913335"
      ];
      postShutdown = [
        "${pkgs.iproute2}/bin/ip rule del from 10.133.35.0/24 table 913335"
        "${pkgs.iproute2}/bin/ip -6 rule del from 133:35::/64 table 913335"
      ];
      peers = [{
        endpoint = "engage.cloudflareclient.com:2408";
        publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        persistentKeepalive = 15;
      }];
    };
  };
}

