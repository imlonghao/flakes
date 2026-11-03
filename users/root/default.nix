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
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBSpTSskzZHanRkpylPPORmidJ4z/jT7OgtIbi4ZwjgeAAAAEXNzaDpDYW5vS2V5Q2FuYXJ5 Canary@CanoKey"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIM2jioeqCNdMHq5vlsn40H/2JEXH8ag9QQNx/tXefSzzAAAACnNzaDpSUDIzNTA= RP2350"
    ];
    shell = pkgs.fish;
  };
}
