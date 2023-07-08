{ config, pkgs, self, sops, ... }:

{
  environment.systemPackages = [ pkgs.borgbackup pkgs.borgmatic ];

  sops.secrets.borgmatic.sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";
  systemd.services.borgmatic.serviceConfig.EnvironmentFile = "/run/secrets/borgmatic";

  services.borgmatic = {
    enable = true;
    settings = {
      storage = {
        encryption_passphrase = "\${PASSPHRASE}";
        compression = "zstd";
      };
      retention = {
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;
      };
    };
  };
}
