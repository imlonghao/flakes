{ config, pkgs, ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  boot.kernel.sysctl = {
    "net.ipv4.conf.wg0458.rp_filter" = 0;
    "net.ipv4.conf.wg1080.rp_filter" = 0;
  };
  networking.wireguard.interfaces = {
    wg0458 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20458;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "au-east1.nodes.huajinet.org:21888";
          publicKey = "LeNGkX12n1Dcq8eNE1HhvpnFxrPlzgWlNncFlHdi5DY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1080 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21080;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "syd.peer.highdef.network:21888";
          publicKey = "Xk9wCuwp3zK4WflTeAKBIjgIlr3+qUwIFCkF2uMyyF8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
