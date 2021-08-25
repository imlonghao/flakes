{ pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).hosthatchsgsingapore1;
in
{
  networking.wireguard.interfaces = {
    wg0604 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.89.1/32 dev wg0604";
      privateKey = wgPrivKey;
      listenPort = 20604;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sgp1.dn42.cas7.moe:21888";
          publicKey = "R8iyaSzF6xx/t4+1wKlYWZWyZOxJDCXlA2BE3OZnsAY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg1876 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.66.57/32 dev wg1876";
      privateKey = wgPrivKey;
      listenPort = 21876;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "n304.dn42.ac.cn:21888";
          publicKey = "DW2erV/Yv/mFTTeO/zE6JaD83KvxMEu8TkK/3uqryhM=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
    wg3699 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.155.7/32 dev wg3699";
      privateKey = wgPrivKey;
      listenPort = 23699;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sg.tsingyao.pub:21888";
          publicKey = "7NP0CESs1L8ODPqYNm8YDizwMe9WKrvUjrULGNyFHVg=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "::/0" "fd00::/8" ];
        }
      ];
    };
  };
}
