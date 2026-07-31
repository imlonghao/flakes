{ config, self, ... }:

{
  sops.secrets.peerfinder-agent.sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";

  services.peerfinder-agent = {
    enable = true;
    secretKeyFile = config.sops.secrets.peerfinder-agent.path;
    openFirewall = true;
  };
}
