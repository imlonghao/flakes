{ config, self, ... }:

{
  sops.secrets."etherguard.super" = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
    restartUnits = [ "etherguard-super.service" ];
  };

  services.etherguard-super = {
    enable = true;
    path = config.sops.secrets."etherguard.super".path;
  };
}
