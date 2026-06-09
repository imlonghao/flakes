{
  config,
  self,
  ...
}:

{
  sops.secrets.niks3 = {
    format = "binary";
    sopsFile = "${self}/secrets/niks3.txt";
  };
  services.niks3-auto-upload = {
    enable = true;
    serverUrl = "https://niks3.esd.cc";
    authTokenFile = config.sops.secrets.niks3.path;
  };
}
