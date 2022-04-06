{ pkgs, ... }:
let
  trustedUserCAKeys = pkgs.writeText "user_ca.pub" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdY=";
in
{
  imports = [ ../cachix ];

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    package = pkgs.nix_2_4;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  boot.cleanTmpDir = true;
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.all.accept_local" = 1;
    "net.ipv4.conf.default.accept_local" = 1;
  };

  environment.systemPackages = [
    pkgs.mtr
    pkgs.tcpdump
    pkgs.wget
  ];

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking.firewall.enable = false;

  services.earlyoom.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    extraConfig = ''
      TrustedUserCAKeys = ${trustedUserCAKeys}
    '';
    knownHosts.ca = {
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdY=";
      hostNames = [ "*" ];
      certAuthority = true;
    };
  };
  services.chrony.enable = true;
  services.vnstat.enable = true;

  sops.gnupg.sshKeyPaths = [ ];
  sops.age.sshKeyPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  time.timeZone = "Asia/Shanghai";

  users.mutableUsers = false;

  programs.fish.enable = true;
}
