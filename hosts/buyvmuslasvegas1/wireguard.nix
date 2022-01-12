{ config, pkgs, ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  networking.wireguard.interfaces = {
    wg31111 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 31111;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = "ffcWCDuBP3YdufFzOaiW2QeZLFG/GXg4QfbWTZ6LVz8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0253 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20253;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sfo1.dn42.moe233.net:21888";
          publicKey = "C3SneO68SmagisYQ3wi5tYI2R9g5xedKkB56Y7rtPUo=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0826 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.196.0/32 dev wg0826";
      privateKeyFile = config.sops.secrets.wireguard.path;
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
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg1817 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21817;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us.skywolf.vm.kskb.eu.org:21888";
          publicKey = "dZzVdXbQPnWPpHk8QfW/p+MfGzAkMBuWpxEIXzQCggY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2032 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22032;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "nv1.us.lapinet27.com:21888";
          publicKey = "KlvNQ7wBwoey0N8YpJYsYuHDrxjpIzHqCh9osAzcEyA=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2464 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg2688 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22688;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lv1-v4.us.dn42.miaotony.xyz:21888";
          publicKey = "vfrrbtKAO5438daHrTD0SSS8V6yk78S/XW7DeFrYLXA=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2980 = {
      ips = [ "fe80::1888:5/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.5/32 peer 172.23.105.3/32 dev wg2980";
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg3308 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.5/32 peer 172.23.99.65/32 dev wg3308";
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23308;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lax01.dn42.testnet.cyou:41888";
          publicKey = "fxzL3/spstTHn0cxaAlVZHIfa1VQP06FKjJL9P/Zzgg=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3743 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23743;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lax1-cn2.bugsur.xyz:21888";
          publicKey = "x8nuSiQ4B9fyV/Qe7htgsjeuPMQPziAvOigOt+FWIgs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3918 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23918;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "v4.us-01.public.nodes.supernoc.net:21888";
          publicKey = "XPPdCmXC7glm/gU3RvGjL+u5VeYbybDhym32aECN2Hg=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
