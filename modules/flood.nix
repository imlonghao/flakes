{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.flood;
in {
  options.services.flood = {
    enable = mkEnableOption "A beautiful web UI for various torrent clients.";
    listen = mkOption {
      type = types.str;
      description = "listen address";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.flood = {
      serviceConfig = with pkgs; {
        ExecStart =
          "${flood}/bin/flood --auth=none --rtsocket /run/rtorrent/rpc.sock -h ${cfg.listen}";
        User = "rtorrent";
        Group = "rtorrent";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "etherguard-edge.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
