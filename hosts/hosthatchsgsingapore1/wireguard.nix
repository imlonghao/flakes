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
          publicKey = "7TIbiifNzh8HxLUM8cBvwmBo/kuaCAUCRahbBMoVA1Q=";
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
          endpoint = "sg1.dn42.moe233.net:21888";
          publicKey = "beaS4l4XBT4eSZBLJcu/u6fbm0mRk0TfuSLkMp8jOkY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0604 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.89.1/32 dev wg0604"
        "${pkgs.iproute2}/bin/ip route change 172.23.89.1 src 172.22.68.2 dev wg0604"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20604;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sgp1.dn42.cas7.moe:21888";
          publicKey = "R8iyaSzF6xx/t4+1wKlYWZWyZOxJDCXlA2BE3OZnsAY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0831 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20831;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sg.dn42.tms.im:21888";
          publicKey = "KlZg3oOjQsaQ0dNkUgHCKyOqULw8+u+llo97X1w5mV4=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1588 = {
      ips = [ "fe80::100/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.16.142/32 dev wg1588"
        "${pkgs.iproute2}/bin/ip route change 172.20.16.142 src 172.22.68.2 dev wg1588"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21588;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sg-sin01.dn42.tech9.io:59771";
          publicKey = "4qLIJ9zpc/Xgvy+uo90rGso75cSrT2F5tBEv+6aqDkY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1876 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.66.57/32 dev wg1876"
        "${pkgs.iproute2}/bin/ip route change 172.22.66.57 src 172.22.68.2 dev wg1876"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21876;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "n304.dn42.ac.cn:21888";
          publicKey = "DW2erV/Yv/mFTTeO/zE6JaD83KvxMEu8TkK/3uqryhM=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2225 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.12.197/32 dev wg2225"
        "${pkgs.iproute2}/bin/ip route change 172.20.12.197 src 172.22.68.2 dev wg2225"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22225;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "dn42-sg.maraun.de:21888";
          publicKey = "rWTIK93+XJaP4sRvrk1gqXxAZgkz6y/axLC4mjuay1I=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2237 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22237;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sg-sin01.dn42.munsternet.eu:21888";
          publicKey = "09m8ilgZ/9jQvVgsGwu2ceR8u6gKAsd+VxH8AzduOHk=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2330 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22330;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = "LNpOdAZMc2RszmMB/JrvGoqLt8aE+p9JyYODKphzyyw=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2331 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22331;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "103.83.156.22:21888";
          publicKey = "I5yRgHFY+qfkRwT6UpVBsUIiA5hmEOv1cU2licfrokw=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2633 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.250.34/32 dev wg2633"
        "${pkgs.iproute2}/bin/ip route change 172.23.250.34 src 172.22.68.2 dev wg2633"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22633;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sin.eastbnd.com:21888";
          publicKey = "m5IfciUmvMEfDkfFQf0jD3GH0F0ChMktOSiLMlJ29wc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
