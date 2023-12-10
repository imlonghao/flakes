{ config, pkgs, self, ... }:
{
  sops.secrets.root = {
    sopsFile = "${self}/secrets/shadow.yml";
    neededForUsers = true;
  };
  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv5fgCyrSdHw1z4Yvdi28fLs413vLFYk5sYyfC1YHJz imlonghao@imlonghao"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeDCr6dY6ScASSNauNDZx1hOjTg80Ih5LWW4z0HDDS2 root@ovhfrgravelines1"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPssSSxz4ZxCS/Tp4TSC4/6P0FQ+bvXWsrl3FTB5denvAAAABHNzaDo= CanoKey"
    ];
    shell = pkgs.fish;
  };
}
