{
  config,
  pkgs,
  self,
  ...
}:
{
  sops.secrets.root = {
    sopsFile = "${self}/secrets/shadow.yml";
    neededForUsers = true;
  };
  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8PcjHlCpkP7we75CoRX6gkKrI7/072xj8G6Y1qisNm openpgp:0xDA96745E"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPssSSxz4ZxCS/Tp4TSC4/6P0FQ+bvXWsrl3FTB5denvAAAABHNzaDo= Pigeon@CanoKey"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB851g+j7f3CPa0FHBiSKu8hlTh2E9wpsv/H0VYpLlj2AAAABHNzaDo= Canary@CanoKey"
    ];
    shell = pkgs.fish;
  };
}
