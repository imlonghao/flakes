{ config, self, ... }:

{
  sops.secrets."etherguard.edge" = {
    sopsFile = "${self}/hosts/${config.nixpkgs.system}/${config.networking.hostName}/secrets.yml";
    restartUnits = [ "etherguard-edge.service" ];
  };

  services.etherguard-edge = {
    enable = true;
    path = config.sops.secrets."etherguard.edge".path;
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.eg_net.rp_filter" = 0;
  };
}
