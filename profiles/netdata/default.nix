{ ... }:
{
  services.netdata = {
    enable = true;
    config = {
      web = {
        mode = "none";
      };
    };
  };
}