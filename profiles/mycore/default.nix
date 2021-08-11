{ profiles, ... }:
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

  networking.firewall.allowPing = true;

  services.earlyoom.enable = true;
  services.openssh.enable = true;
}
