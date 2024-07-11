{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_27;
    daemon.settings = {
      "default-address-pools" = [
        {
          "base" = "100.65.0.0/16";
          "size" = 24;
        }
        {
          "base" = "fc00:d0c1:e300::/48";
          "size" = 64;
        }
      ];
    };
  };
}
