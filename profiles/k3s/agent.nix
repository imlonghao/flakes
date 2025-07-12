{ config, ... }:
{
  imports = [ ./generic.nix ];
  services.k3s = {
    role = "agent";
    tokenFile = config.sops.secrets."k3s-agent".path;
  };
}
