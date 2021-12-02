{ config, pkgs, self, sops, ... }:

{
  sops.secrets.k3stoken.sopsFile = "${self}/secrets/k3s.yml";
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.sops.secrets.k3stoken.path;
    serverAddr = "https://100.64.88.62:6443";
  };
  services.k3s-no-ctstate-invalid.enable = true;
  environment.systemPackages = [ pkgs.iptables ];
}

