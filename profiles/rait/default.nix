{ age, config, pkgs, self, ... }:

{
  environment.systemPackages = [ pkgs.rait ];
  age.secrets."rait.sh" = {
    file = "${self}/secrets/rait/rait.sh";
    mode = "0500";
  };
  age.secrets."rait.conf".file = "${self}/secrets/rait/${config.networking.hostName}.conf";
  services.rait = {
    enable = true;
    path = "/run/secrets/rait.sh";
  };
  boot.kernel.sysctl."net.ipv4.conf.gravity.rp_filter" = 0;
}
