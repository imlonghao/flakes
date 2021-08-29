{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.vault ];
  services.vault = {
    enable = true;
    storageBackend = "consul";
  };
}
