{ config, self, ... }:

{
  sops.secrets.pingfinder.sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
  services.pingfinder = {
    enable = true;
    environmentFile = config.sops.secrets.pingfinder.path;
  };
}
