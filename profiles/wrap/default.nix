{ config, self, ... }:

{
  sops.secrets.wrap.sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
  wrap = {
    enable = true;
    path = config.sops.secrets.wrap.path;
  };
}
