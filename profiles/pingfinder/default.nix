{ config, self, sops, ... }:

{
  sops.secrets.pingfinder.sopsFile =
    "${self}/hosts/${config.networking.hostName}/secrets.yml";
  services.pingfinder = {
    enable = true;
    environmentFile = config.sops.secrets.pingfinder.path;
  };
}
