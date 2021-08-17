{ config, self, ... }:

let
  cfg = (builtins.fromJSON (builtins.readFile "${self}/secrets/teleport.json"));
in
{
  networking.nameservers = [ "100.64.0.53" "1.1.1.1" "8.8.8.8" ];
  networking.interface.lo.ip4 = [
    { address = "100.64.0.53"; prefixLength = 32; }
  ];
  services.consul = {
    enable = true;
    interface.bind = "gravity";
    extraConfig = {
      start_join = [ "100.64.123.209" "100.64.123.246" "100.64.123.91" ];
    };
  };
}
