{ config, self, sops, ... }:

{
  sops.secrets.wrap.sopsFile =
    "${self}/hosts/${config.networking.hostName}/secrets.yml";
  wrap = {
    enable = true;
    path = config.sops.secrets.wrap.path;
  };
}
