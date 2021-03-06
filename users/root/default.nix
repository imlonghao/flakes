{ config, pkgs, self, ... }:
{
  sops.secrets.root = {
    sopsFile = "${self}/secrets/shadow.yml";
    neededForUsers = true;
  };
  users.users.root = {
    passwordFile = config.sops.secrets.root.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv5fgCyrSdHw1z4Yvdi28fLs413vLFYk5sYyfC1YHJz imlonghao@imlonghao"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdjuyWpE3wwjLVXpF/Rs0JjSk9Q6QHhQlrjspFzFA7M root@hetznerdefalkenstein1"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9dyYPiJZc/TwNLcQBDDAVHGkpofq1rfgpd18VjrBwp root@hetznerdefalkenstein2"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPssSSxz4ZxCS/Tp4TSC4/6P0FQ+bvXWsrl3FTB5denvAAAABHNzaDo= CanoKey"
    ];
    shell = pkgs.fish;
  };
}
