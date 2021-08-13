{ age, config, self, ... }:

{
  age.secrets."rait.sh" = {
    file = "${self}/secrets/rait/rait.sh";
    mode = "0500";
  };
  age.secrets."rait.conf".file = "${self}/secrets/rait/${config.networking.hostName}.conf";
  environment.etc."rait/rait.conf" = {
    source = age.secrets."rait.conf".path;
    mode = "0400";
  };
  services.rait = {
    enable = true;
    path = age.secrets."rait.sh".path;
  };
}
