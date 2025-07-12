{
  config,
  pkgs,
  self,
  ...
}:
let
  ip4 = "100.64.1.${toString config.services.ranet.id}";
  ip6 = "fd99:100:64:1::${toString config.services.ranet.id}";
in
{
  sops.secrets."k3s-agent" = {
    format = "binary";
    sopsFile = "${self}/secrets/k3s-agent.txt";
  };
  services.k3s = {
    enable = true;
    serverAddr = "https://k3s.ni.sb:6443";
    extraFlags = [
      "--node-ip=${ip4},${ip6}"
      "--flannel-iface=gravity"
    ];
  };
  services.k3s-no-ctstate-invalid.enable = true;
  environment.systemPackages = [
    pkgs.iptables
    pkgs.openiscsi
  ];
  programs.fish.shellAliases = {
    kubectl = "k3s kubectl";
  };
  systemd.tmpfiles.rules = [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];
  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${config.networking.hostName}";
  };
  boot.kernelModules = [ "dm_crypt" ];
}
