{ config, self, ... }:
{
  imports = [ ./generic.nix ];
  sops.secrets."k3s-server" = {
    format = "binary";
    sopsFile = "${self}/secrets/k3s-server.txt";
  };
  services.k3s = {
    role = "server";
    tokenFile = config.sops.secrets."k3s-server".path;
    extraFlags = [
      "--disable=traefik"
      "--tls-san=k3s.ni.sb"
      "--agent-token-file=${config.sops.secrets.k3s-agent.path}"
      "--cluster-cidr 10.42.0.0/16,fc00:42::/56"
      "--service-cidr 10.43.0.0/16,fc00:43::/112"
      "--flannel-ipv6-masq"
      "--flannel-backend=host-gw"
    ];
  };
}
