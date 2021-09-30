{ age, pkgs, self, ... }:

{
  age.secrets."k3s.token".file = "${self}/secrets/k3s.token";
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "/run/secrets/k3s.token";
    serverAddr = "https://100.64.88.62:6443";
  };
  services.k3s-no-ctstate-invalid.enable = true;
  environment.systemPackages = [ pkgs.iptables ];
}

