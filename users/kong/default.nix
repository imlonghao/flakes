{ config, self, ... }:
{
  sops.secrets.kong = {
    sopsFile = "${self}/secrets/shadow.yml";
    neededForUsers = true;
  };
  users.users.kong = {
    hashedPasswordFile = config.sops.secrets.kong.path;
  };
}
