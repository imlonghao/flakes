{ pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).uovzcnhongkong1;
in
{
  networking.wireguard.interfaces = {
    wg2526 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.167.100/32 dev wg2526";
      privateKey = wgPrivKey;
      listenPort = 22526;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk.awsl.ee:51818";
          publicKey = "FDW5S+3nNS883Q5mKVwym0dwEYKF+nuQ1rPZ+sWVqgc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2980 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.105.2/32 dev wg2980";
      privateKey = wgPrivKey;
      listenPort = 22980;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "tyo1.jp.dn42.yuuta.moe:21888";
          publicKey = "nQ/5+M6MGsGJPWLQtEKBm8d1IzKZZZvIsOeTywhsH3Q=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3618 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.51.98/32 dev wg3618";
      privateKey = wgPrivKey;
      listenPort = 23618;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "15.dyn.neo.jerryxiao.cc:50096";
          publicKey = "XhFVaLvuWT95gfI5e95bV84pESKenAgL5ulq+Q0KoSI=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3914 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.53.105/32 dev wg3914";
      privateKey = wgPrivKey;
      listenPort = 23914;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk1.g-load.eu:21888";
          publicKey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
