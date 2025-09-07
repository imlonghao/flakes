{ config, self, ... }:
{
  sops.secrets."globalping" = {
    sopsFile = "${self}/secrets/globalping.txt";
    format = "binary";
  };
  virtualisation.oci-containers.containers = {
    globalping = {
      image = "globalping/globalping-probe";
      environmentFiles = [ config.sops.secrets.globalping.path ];
      pull = "newer";
      networks = [ "host" ];
      capabilities = {
        NET_RAW = true;
      };
    };
  };
}
