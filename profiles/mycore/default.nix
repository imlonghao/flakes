{ pkgs, ... }:
let
  trustedUserCAKeys = pkgs.writeText "user_ca.pub" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdY=";
in
{
  imports = [ ../cachix ];

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  system.stateVersion = "22.11";

  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.all.accept_local" = 1;
    "net.ipv4.conf.default.accept_local" = 1;
    "fs.file-max" = 2097152;
    "fs.inotify.max_user_instances" = 512;
  };

  environment.systemPackages = [
    pkgs.bottom
    pkgs.mtr
    pkgs.tcpdump
    pkgs.wget
  ];

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking.firewall.enable = false;

  services.earlyoom.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    extraConfig = ''
      TrustedUserCAKeys = ${trustedUserCAKeys}
    '';
    knownHosts.ca = {
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdY=";
      hostNames = [ "*" ];
      certAuthority = true;
    };
  };
  services.chrony = {
    enable = true;
    extraConfig = "rtcsync";
  };
  services.vnstat.enable = true;

  sops.gnupg.sshKeyPaths = [ ];
  sops.age.sshKeyPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];

  time.timeZone = "Asia/Shanghai";

  users.mutableUsers = false;

  programs.fish.enable = true;

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "40960";
  }];

  security.pki.certificates = [
    ''
      imlonghao Root CA
      =========
      -----BEGIN CERTIFICATE-----
      MIIB0jCCAVigAwIBAgIIYrwQ5kKMldwwCgYIKoZIzj0EAwMwMDESMBAGA1UEChMJ
      aW1sb25naGFvMRowGAYDVQQDExFpbWxvbmdoYW8gUm9vdCBDQTAeFw0yMzA0Mjgw
      MDAwMDBaFw00ODA0MjcyMzU5NTlaMDAxEjAQBgNVBAoTCWltbG9uZ2hhbzEaMBgG
      A1UEAxMRaW1sb25naGFvIFJvb3QgQ0EwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAATW
      MRUOUlhMCGrMxsCVLHnRxqqnV/jPXpfAxyLyAqub33j05pzM+n/nmxriyWLdYWpA
      8LmYAZuW+NgSyGSY2MNkaodgad/AmEP8yKHKN0lCE1vnaI6rahr84LZeLxAhAduj
      PzA9MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFA5n5ZGOEHiSBzZBQNxSPNNx
      8xjeMAsGA1UdDwQEAwIBBjAKBggqhkjOPQQDAwNoADBlAjEA9e/c7DsX/y2QV0yp
      YvyzR4pbqFKVlz6TvtmI1iBF5DZ/eewpep6XUYtnZHZ6iDB3AjBpe1teuAQUzOr+
      sNAFvntNFUFAdc0qKX7voeDPEguMblmOJvyV2iiQQm4dQAgG5fA=
      -----END CERTIFICATE-----
    ''
  ];

}
