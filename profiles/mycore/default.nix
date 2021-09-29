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
      experimental-features = nix-command flakes ca-references ca-derivations
    '';
  };

  boot.cleanTmpDir = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 0; 
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

  time.timeZone = "Asia/Shanghai";

  users.mutableUsers = false;
}
