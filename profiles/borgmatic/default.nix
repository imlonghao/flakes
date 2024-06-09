{ config, inputs, pkgs, self, sops, ... }:

{
  disabledModules = [ "services/backup/borgmatic.nix" ];
  #  imports = [ "${inputs.latest}/nixos/modules/services/backup/borgmatic.nix" ];

  environment.systemPackages = [ pkgs.borgbackup pkgs.borgmatic ];

  sops.secrets.borgmatic.sopsFile =
    "${self}/hosts/${config.networking.hostName}/secrets.yml";
  systemd.services.borgmatic.serviceConfig.EnvironmentFile =
    "/run/secrets/borgmatic";

  services.borgmatic = {
    enable = true;
    settings = {
      encryption_passphrase = "\${PASSPHRASE}";
      compression = "zstd";
      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 6;
    };
  };
}
