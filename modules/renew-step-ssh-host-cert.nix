{ config, pkgs, lib, ... }:
let cfg = config.services.rsshc;
in {
  options.services.rsshc = {
    enable = lib.mkEnableOption "Renew Step SSH Host Certificate";
    path = lib.mkOption {
      type = lib.types.str;
      description = "path to the root ca";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.rsshc = {
      serviceConfig = {
        ExecStart =
          "${pkgs.step-cli}/bin/step ssh renew -f --ca-url https://ca.esd.cc --root ${cfg.path} /persist/etc/ssh/step-cert.pub /persist/etc/ssh/ssh_host_ed25519_key";
        ExecStartPost = "${pkgs.systemd}/bin/systemctl try-restart sshd";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
    systemd.timers.rsshc = {
      timerConfig = {
        OnCalendar = "weekly";
        Unit = "rsshc.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
