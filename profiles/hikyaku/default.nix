{ self, config, ... }:
{
  sops.secrets.hikyaku = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
    restartUnits = [ "hikyaku-server.service" ];
  };

  services.hikyaku-server = {
    enable = true;
    pskFile = config.sops.secrets.hikyaku.path;
    openFirewall = true;
  };
}
