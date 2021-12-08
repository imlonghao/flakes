{ age, config, pkgs, self, sops, ... }:

{
  sops.secrets."etherguard.edge" = {
    sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";
    restartUnits = [ "etherguard-edge.service" ];
  };

  services.etherguard-edge = {
    enable = true;
    path = config.sops.secrets."etherguard.edge".path;
  };
}
