{ config, pkgs, self, sops, ... }:

{
  sops.secrets."tuic".sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";

  services.tuic = {
    enable = true;
    path = config.sops.secrets."tuic".path;
  };
}

