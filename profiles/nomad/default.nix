{ config, self, ... }:

let
  cfg = (builtins.fromJSON (builtins.readFile "${self}/secrets/teleport.json"));
in
{
  networking.nameservers = [ "100.64.0.53" "1.1.1.1" "8.8.8.8" ];
  networking.interfaces.lo.ipv4 = [
    { address = "100.64.0.53"; prefixLength = 32; }
  ];
  services.consul = {
    enable = true;
    interface.bind = "gravity";
    extraConfig = {
      start_join = [ "100.64.88.22" "100.64.88.42" "100.64.88.50" ];
    };
  };
  services.nomad = {
    enable = true;
    settings = {
      leave_on_interrupt = true;
      leave_on_terminate = true;
      disable_update_check = true;
      datacenter = "dc";
      client = {
        enabled = true;
        servers = [ "100.64.88.22" "100.64.88.42" "100.64.88.50" ];
      };
    };
  };
}
