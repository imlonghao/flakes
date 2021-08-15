{ config, self, ... }:

let
  cfg = (builtins.fromJSON (builtins.readFile "${self}/secrets/teleport.json"));
in
{
  services.teleport = {
    enable = true;
    teleport = {
      auth_token = cfg.auth_token."${config.networking.hostName}";
      auth_servers = cfg.auth_servers;
      ca_pin = cfg.ca_pin;
    };
  };
}
