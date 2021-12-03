{ pkgs, ... }:
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
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  boot.cleanTmpDir = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv6.conf.all.forwarding" = 1;
  };

  environment.systemPackages = [
    pkgs.mtr
    pkgs.tcpdump
  ];

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking.firewall.enable = false;

  services.earlyoom.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
  services.chrony.enable = true;

  sops.age.sshKeyPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  time.timeZone = "Asia/Shanghai";

  users.mutableUsers = false;

  programs.fish.enable = true;
}
