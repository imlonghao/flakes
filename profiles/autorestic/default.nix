{ config, pkgs, self, ... }:

{
  environment.systemPackages = [ pkgs.restic pkgs.autorestic ];

  sops.secrets."autorestic".sopsFile =
    "${self}/hosts/${config.networking.hostName}/secrets.yml";

  services.autorestic = { enable = true; };
}
