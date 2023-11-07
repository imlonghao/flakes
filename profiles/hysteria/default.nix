{ config, pkgs, self, sops, ... }:

{
  sops.secrets.hysteria = {
    sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";
    owner = "hysteria";
    group = "hysteria";
  };

  services.hysteria = {
    enable = true;
    path = config.sops.secrets."hysteria".path;
  };
}

