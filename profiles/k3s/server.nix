{ config, pkgs, self, sops, ... }:

{
  sops.secrets."k3s-agent" = {
    format = "binary";
    sopsFile = "${self}/secrets/k3s-agent.txt";
  };
  sops.secrets."k3s-server" = {
    format = "binary";
    sopsFile = "${self}/secrets/k3s-server.txt";
  };
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets."k3s-server".path;
    serverAddr = "https://k3s.ni.sb:6443";
    extraFlags = [
      "--disable=traefik"
      "--tls-san=k3s.ni.sb"
      "--node-ip=${config.services.etherguard-edge.ipv4}"
      "--agent-token-file=${config.sops.secrets.k3s-agent.path}"
    ];
  };
  services.k3s-no-ctstate-invalid.enable = true;
  environment.systemPackages = [ pkgs.iptables ];
}
