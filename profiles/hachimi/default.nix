{ self, config, ... }:
{
  sops.secrets.hachimi.sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";
  services.hachimi = {
    enable = true;
    path = "/run/secrets/hachimi";
  };
}
