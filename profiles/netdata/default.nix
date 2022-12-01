{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.netdata ];
  services.netdata = {
    enable = true;
    config = {
      web = {
        mode = "none";
      };
    };
  };
}
