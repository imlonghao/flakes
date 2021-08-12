{ config, self, ... }:

let
  cfg = (builtins.fromJSON (builtins.readFile "${self}/secrets/rait.json"));
in
{
  services.rait = {
    enable = true;
    registry = cfg.registry;
    operator_key = cfg."${config.networking.hostName}".operator_key;
    private_key = cfg."${config.networking.hostName}".private_key;
    ip = cfg."${config.networking.hostName}".ip;
    port = cfg."${config.networking.hostName}".port;
  };
}
