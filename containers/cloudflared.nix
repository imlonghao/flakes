{ config, self, ... }:
{
  sops.secrets."cloudflared" = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
  };
  virtualisation.oci-containers.containers = {
    cloudflared = {
      image = "cloudflare/cloudflared:2026.10.4";
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
