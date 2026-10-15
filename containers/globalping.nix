{
  config,
  self,
  lib,
  ...
}:
{
  sops.secrets."globalping" = {
    sopsFile = "${self}/secrets/globalping.txt";
    format = "binary";
  };
  # The probe exits successfully for scheduled restarts; restart it on clean exits too.
  systemd.services.podman-globalping.serviceConfig.Restart = lib.mkForce "always";

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
