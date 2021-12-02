{ age, config, pkgs, self, sops, ... }:

{
  environment.systemPackages = [ pkgs.rait ];

  sops.secrets."rait.conf".sopsFile = "${self}/hosts/${config.networking.hostName}/secrets.yml";

  services.rait = {
    enable = true;
    path = "${pkgs.rait}/bin/rait.sh";
  };
}
