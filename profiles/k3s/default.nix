{ age, self, ... }:

{
  age.secrets."k3s.token".file = "${self}/secrets/k3s.token";
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "/run/secrets/rait.sh";
    serverAddr = "https://100.64.88.62:6443";
  };
}