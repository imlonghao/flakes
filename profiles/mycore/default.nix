{ pkgs, ... }:
let
  trustedUserCAKeys = pkgs.writeText "user_ca.pub"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCRbFsPcCoFmDEXeflbVOboRpFKG69mOS8gtrohxWuewuc8bUgUFpgPDedbN77eKHdEDnnGec8Q9Yco5LpUu6eY=";
in {
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

  system.stateVersion = "23.11";

  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.all.accept_local" = 1;
    "net.ipv4.conf.default.accept_local" = 1;
    "fs.file-max" = 2097152;
    "fs.inotify.max_user_instances" = 512;
    # zram
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
    # https://blog.cloudflare.com/optimizing-tcp-for-high-throughput-and-low-latency/
    "net.ipv4.tcp_rmem" = "8192 262144 536870912";
    "net.ipv4.tcp_wmem" = "4096 16384 536870912";
    "net.ipv4.tcp_adv_win_scale" = "-2";
    "net.ipv4.tcp_collapse_max_bytes" = 6291456;
    "net.ipv4.tcp_notsent_lowat" = 131072;
  };

  environment.systemPackages = [ pkgs.bottom pkgs.mtr pkgs.tcpdump pkgs.wget ];

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking.firewall.enable = false;

  services.earlyoom.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    extraConfig = ''
      TrustedUserCAKeys ${trustedUserCAKeys}
    '';
    knownHosts.ca = {
      publicKey =
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBO5G2CWEODVl6DJKYy36co6J6K12Y+OftCXUihhGpvKbKNM5/vImNTwDzAyCKrKcM8Da+1WTIJnIZM9qlLG8ZdY=";
      hostNames = [ "*" ];
      certAuthority = true;
    };
    knownHosts.step-ca = {
      publicKey =
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBH0r5oq3zgEQkOWsN0q8Y9Q451cT0PVp3rTJw14B4QuHLmULYfAfjXUa/ve3EtIFetGefyiDUJa2r60Cd5gBOM4=";
      hostNames = [ "*" ];
      certAuthority = true;
    };
  };
  services.chrony = {
    enable = true;
    extraConfig = ''
      rtcsync
    '';
    enableRTCTrimming = false;
  };
  services.vnstat.enable = true;

  sops.gnupg.sshKeyPaths = [ ];
  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  time.timeZone = "Asia/Shanghai";

  users.mutableUsers = false;

  programs.fish.enable = true;

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "40960";
  }];

  security.pki.certificates = [''
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

    imlonghao Root CA (step-ca)
    =========
    -----BEGIN CERTIFICATE-----
    MIIBozCCAUqgAwIBAgIRAPNyvyHMBh1vgQFB9R/gDOowCgYIKoZIzj0EAwIwMDES
    MBAGA1UEChMJaW1sb25naGFvMRowGAYDVQQDExFpbWxvbmdoYW8gUm9vdCBDQTAe
    Fw0yMzEyMTAxMTI0NTRaFw0zMzEyMDcxMTI0NTRaMDAxEjAQBgNVBAoTCWltbG9u
    Z2hhbzEaMBgGA1UEAxMRaW1sb25naGFvIFJvb3QgQ0EwWTATBgcqhkjOPQIBBggq
    hkjOPQMBBwNCAAQHAdWXqylu6Yn9NtnE/K3l7vL0cQbMEYd/Rti+2l5m+UVW37jB
    ERA5NCym/xq4q0oflcEOr04xjtXP4kAMjb/To0UwQzAOBgNVHQ8BAf8EBAMCAQYw
    EgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQUw+daBEc1HLovYD1n0lZjDXk7
    sIkwCgYIKoZIzj0EAwIDRwAwRAIgQz5bAOfSGLHliTwMIsP7N9ZeGOq9d1+BEm1F
    gv7EeZ4CIHFAg1O33OZ40uyet9XoSSLH44OCUmByJ5OItY4kJyml
    -----END CERTIFICATE-----
  ''];

  zramSwap = {
    enable = true;
    priority = 100;
  };

  programs.htop = {
    enable = true;
    settings = {
      column_meters_0 = "LeftCPUs Memory Swap CPU NetworkIO";
      column_meter_modes_0 = "1 1 1 2 2";
      column_meters_1 = "RightCPUs Tasks LoadAverage Uptime DiskIO";
      column_meter_modes_1 = "1 2 2 2 2";
      detailed_cpu_time = 1;
      show_cpu_temperature = 1;
    };
  };

}
