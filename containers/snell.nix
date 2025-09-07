{ config, self, ... }:
{
  sops.secrets."snell" = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
  };
  virtualisation.oci-containers.containers = {
    snell = {
      image = "geekdada/snell-server:5.0.0";
      environmentFiles = [ config.sops.secrets.snell.path ];
      networks = [ "hosts" ];
    };
  };
}
