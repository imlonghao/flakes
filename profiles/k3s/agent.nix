{ config, pkgs, self, sops, ... }:
let
  ip = builtins.replaceStrings [ "/24" ] [ "" ]
    config.services.etherguard-edge.ipv4;
in
{
  sops.secrets."k3s-agent" = {
    format = "binary";
    sopsFile = "${self}/secrets/k3s-agent.txt";
  };
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.sops.secrets."k3s-agent".path;
    serverAddr = "https://k3s.ni.sb:6443";
    extraFlags = [
      "--node-ip=${ip}"
    ];
  };
  services.k3s-no-ctstate-invalid.enable = true;
  environment.systemPackages = [ pkgs.iptables ];
}
