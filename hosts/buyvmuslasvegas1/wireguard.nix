{ pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).buyvmuslasvegas1;
in
{
  networking.wireguard.interfaces = { };
}
