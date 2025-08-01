{
  self,
  config,
  pkgs,
  ...
}:

{
  sops.secrets.komari-agent = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
    mode = "0444";
  };
  services.komari-agent = {
    enable = true;
    endpoint = "https://komari.esd.cc";
    token = "/run/secrets/komari-agent";
    include-mountpoint = [ "/persist" ];
  };
}
