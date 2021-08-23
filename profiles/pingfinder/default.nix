{ config, self, ... }:

let
  cfg = (builtins.fromJSON (builtins.readFile "${self}/secrets/pingfinder.json"));
in
{
  services.pingfinder = {
    enable = true;
    uuid = cfg."${config.networking.hostName}";
  };
}
