{ ... }:
{
  imports = [ ../cachix ];

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes ca-references ca-derivations
    '';
  };

  boot.cleanTmpDir = true;

  networking.firewall.enable = false;

  services.earlyoom.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.mutableUsers = false;
}
