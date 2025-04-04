{ config, self, ... }:

{
  sops.secrets."hysteria.yaml" = {
    sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";
    owner = "hysteria";
    group = "hysteria";
  };

  services.hysteria = {
    enable = true;
    path = config.sops.secrets."hysteria.yaml".path;
  };
}

