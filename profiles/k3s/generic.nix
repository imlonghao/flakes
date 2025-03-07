{ config, pkgs, self, sops, ... }:
let
  ip4 = builtins.replaceStrings [ "/24" ] [ "" ]
    config.services.etherguard-edge.ipv4;
  ip6 = builtins.replaceStrings [ "/64" ] [ "" ]
    config.services.etherguard-edge.ipv6;
in {
  sops.secrets."k3s-agent" = {
    format = "binary";
    sopsFile = "${self}/secrets/k3s-agent.txt";
  };
  services.k3s = {
    enable = true;
    serverAddr = "https://k3s.ni.sb:6443";
    extraFlags = [ "--node-ip=${ip4},${ip6}" "--flannel-iface=eg_net" ];
  };
  services.k3s-no-ctstate-invalid.enable = true;
  environment.systemPackages = [ pkgs.iptables pkgs.openiscsi ];
  programs.fish.shellAliases = { kubectl = "k3s kubectl"; };
  systemd.tmpfiles.rules =
    [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];
  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${config.networking.hostName}";
  };
  boot.kernelModules = [ "dm_crypt" ];
}
