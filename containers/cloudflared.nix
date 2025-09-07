{ config, self, ... }:
{
  sops.secrets."cloudflared" = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
  };
  virtualisation.oci-containers.containers = {
    cloudflared = {
      image = "cloudflare/cloudflared:2025.8.1";
      environmentFiles = [ config.sops.secrets.cloudflared.path ];
      networks = [ "host" ];
      cmd = [
        "tunnel"
        "--no-autoupdate"
        "run"
      ];
    };
  };
}
