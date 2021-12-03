{ config, pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).hetznerdefalkenstein1;
in
{
  sops.secrets.wireguard.sopsFile = "./secrets.yml";
  networking.wireguard.interfaces = {
    wg31111 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 31111;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = "YnoqhBTjO0+2vj/1lXqzOmvKeCwZ4q3BJzNyxN/zQ00=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0197 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.190.96/32 dev wg0197";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 20197;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "himalia.dn42.n0emis.eu:21888";
          publicKey = "ObF+xGC6DdddJer0IUw6nzC0RqzeKWwEiQU0ieowzhg=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0345 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.49.33/32 dev wg0345";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 20345;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "gw1.fsn.dn42.herrtxbias.me:21888";
          publicKey = "T0Ef2ojHaT1gJjn/Je8VeKiWx0k6MXSnlsYR6Vm7TQ0=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0385 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.32.36/32 dev wg0385";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 20385;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de01.dn42.fullser.net:21888";
          publicKey = "znU3rjoLbYM11PpPlW1BocQFcxuhBbTJM/djesBvEUs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0499 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 20499;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "138.201.54.47:41888";
          publicKey = "p4yaGWSl2p2Pe3GxUQ3OQREoKPqiSK3svc8+aHnuYzs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1588 = {
      ips = [ "fe80::100/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.16.141/32 dev wg1588";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 21588;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de-fra02.dn42.tech9.io:56292";
          publicKey = "MD1EdVe9a0yycUdXCH3A61s3HhlDn17m5d07e4H33S0=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1592 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.99.191/32 dev wg1592";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 21592;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de01.dn42.ca.melusfer.us:41888";
          publicKey = "7zViBU5dDWV3pxnIGX2ixQmXIgRwvmIW7qwmCgWctzc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1862 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 21862;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "ger1-de.alphvino.com:21888";
          publicKey = "Utag1F2oPnA8Omw7yvBhGk3xDMIRdhwlA7eLtAvSEnE=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2980 = {
      ips = [ "fe80::1888:4/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.4/32 peer 172.23.105.4/32 dev wg2980";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 22980;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "fra1.de.dn42.yuuta.moe:21888";
          publicKey = "GYEhSHmPD0pVX3xBKa7SAwnuCyMA2oOsaHBgFpPO4X4=";
          presharedKey = "iHxtuu7sFtvR/nsOA2m3T4Lt3w8P4VzvLKHWAm23a1w=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3088 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.100.195/32 dev wg3088";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 23088;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "fra1-de.dn42.6700.cc:21888";
          publicKey = "TWQhJYK+ynNz7A4GMAQSHAyUUKTnAYrBfWTzzjzhAFs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3914 = {
      ips = [ "fe80::1888/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.53.97/32 dev wg3914";
      privateKeyFile = builtins.toPath config.sops.secrets.wireguard.path;
      listenPort = 23914;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de2.g-load.eu:21888";
          publicKey = "B1xSG/XTJRLd+GrWDsB06BqnIq8Xud93YVh/LYYYtUY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
