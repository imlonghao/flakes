{ pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).buyvmuslasvegas1;
in
{
  networking.wireguard.interfaces = {
    wg0588 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.110.68/32 dev wg0588";
      privateKey = wgPrivKey;
      listenPort = 20588;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "fnc.l.x6c.us:21888";
          publicKey = "V4Cb9Jy5evG3XTUBrDWbneEE4IkP/hE8g35i4gQ53RM=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0826 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.196.0/32 dev wg0826";
      privateKey = wgPrivKey;
      listenPort = 20826;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "v4.la.dn42.dgy.xyz:21888";
          publicKey = "IXjFALJFTr24HAhXKDsCnTRXmlc3kJHJiR4Nr44l5Uw=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1123 = {
      ips = [ "fe80::1888/64" ];
      privateKey = wgPrivKey;
      listenPort = 21123;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lax.ccp.ovh:21888";
          publicKey = "Z6OKJSR1sxMBgUd1uXEe/UxoBsOvRgbTnexy7z/ryUI=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2464 = {
      ips = [ "fe80::1888/64" ];
      privateKey = wgPrivKey;
      listenPort = 22464;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "las.dneo.moeternet.com:21888";
          publicKey = "viR4CoaJTBHROo/Bgbb27hQ2ttr8AbByGY/yOz3D3GY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2980 = {
      ips = [ "fe80::1888:5/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.5/32 peer 172.23.105.3/32 dev wg2980";
      privateKey = wgPrivKey;
      listenPort = 22980;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sjc1.us.dn42.yuuta.moe:21888";
          publicKey = "2ev+fMK6mIP/v0S9Sq7MlqLhNn0La1VpYiPomgPTD2g=";
          presharedKey = "eDDRji2SoboBoAjQJUCZdsXN9iJJdaxy679BR6F0ukI=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
