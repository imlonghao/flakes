{ self, config, ... }:
{
  sops.secrets.hysteria2 = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
    restartUnits = [ "hysteria2.service" ];
  };

  services.hysteria2 = {
    enable = true;
    configFile = config.sops.secrets.hysteria2.path;
  };
}
