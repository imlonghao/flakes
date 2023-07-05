{ ... }:
{
  services.netdata.configDir = {
    "stream.conf" =  pkgs.writeText "stream.conf" ''
      [stream]
      enabled = yes
      destination = 100.64.88.24
      api key = 040ed080-a060-4a06-ace3-c49408623721
    '';
  };
}
