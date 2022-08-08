{ ... }:

{

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "default-address-pools" = [
        {
          "base" = "100.65.0.0/16";
          "size" = 24;
        }
      ];
    };
  };

}
