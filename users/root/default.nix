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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdUWvplO6J6PJoskgme1TeVw/9XGp9fLZ1862VL2jzonEPqo0WReBzy1yK8c4f/snM+am7/aJ5PmT3NgnYfpjgEkge6+OiZSB7eVM6l/FT+h0AUoLw9vJmlwSyJObOrNCD47d9iyJJbJrdm9f2NwSk1YTHwpDojP4Gtyke+VRuoLnqfzYQGFFvXhZulZFLSOm/vbQ+j37RlLQO5icMr3cpSxUvUCpH2qVyws2WOJ0HCifNYhOho+mi6XFGdh00uGKhEhs/AbqaSuxx0tw6HdWVmJxTZA1/GeNh7HKw+Al/I1f+i9ZFZ0mmyTBM38+Viux/iPTAj4IxBE7qvlSgD8Y9YnQDA6yWVZcVEZBhiwT1mUUzvkw2Sosk8VdDibzNYWHizc7Yh5BofxdwEyZnQgqNPLInabgbsu1ldjFJBmRs1ZR2YvDxeviW/66/woV2B6eLWv6jf2oer7tgwU/wb/yfVEFmpvX5hq5ky3zqwzenQWCtOHouoEbG/QeFDEMksGM= Rundeck"
    ];
    shell = pkgs.fish;
  };
}
