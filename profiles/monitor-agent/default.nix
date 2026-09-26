{
  self,
  config,
  ...
}:

{
  sops.secrets.monitor-agent.sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";

  services.monitor-agent = {
    enable = true;
    endpoint = "https://monitor.esd.cc";
    token = config.sops.secrets.monitor-agent.path;
  };
}
