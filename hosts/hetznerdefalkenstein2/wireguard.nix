{ config, pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).hetznerdefalkenstein1;
in
{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  boot.kernel.sysctl = {
    "net.ipv4.conf.wg64719.rp_filter" = 0;
    "net.ipv4.conf.wg0197.rp_filter" = 0;
    "net.ipv4.conf.wg0289.rp_filter" = 0;
    "net.ipv4.conf.wg0385.rp_filter" = 0;
    "net.ipv4.conf.wg0499.rp_filter" = 0;
    "net.ipv4.conf.wg1588.rp_filter" = 0;
    "net.ipv4.conf.wg1592.rp_filter" = 0;
    "net.ipv4.conf.wg3088.rp_filter" = 0;
    "net.ipv4.conf.wg3914.rp_filter" = 0;
  };
  networking.wireguard.interfaces = {
    wg64719 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.119.1/32 dev wg64719"
        "${pkgs.iproute2}/bin/ip route change 172.22.119.1 src 172.22.68.4 dev wg64719"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 64719;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de-fra.dn42.lutoma.org:42758";
          publicKey = "pI9qB/y5L1iSOxFgam4uoBk2So+P52lAgYC3k8XS9zU=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0197 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.190.96/32 dev wg0197"
        "${pkgs.iproute2}/bin/ip route change 172.20.190.96 src 172.22.68.4 dev wg0197"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg0289 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.101.105/32 dev wg0289"
        "${pkgs.iproute2}/bin/ip route change 172.21.101.105 src 172.22.68.4 dev wg0289"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20289;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "5.255.110.150:21888";
          publicKey = "Pugoi4bu56XBPKG9d8fVbcWHfgbf/eZZJU8IB2n/Ig0=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0385 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.32.36/32 dev wg0385"
        "${pkgs.iproute2}/bin/ip route change 172.23.32.36 src 172.22.68.4 dev wg0385"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.33.65/32 dev wg0499"
        "${pkgs.iproute2}/bin/ip route change 172.23.33.65 src 172.22.68.4 dev wg0499"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.16.141/32 dev wg1588"
        "${pkgs.iproute2}/bin/ip route change 172.20.16.141 src 172.22.68.4 dev wg1588"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.99.191/32 dev wg1592"
        "${pkgs.iproute2}/bin/ip route change 172.21.99.191 src 172.22.68.4 dev wg1592"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg3088 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.100.195/32 dev wg3088"
        "${pkgs.iproute2}/bin/ip route change 172.21.100.195 src 172.22.68.4 dev wg3088"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.53.97/32 dev wg3914"
        "${pkgs.iproute2}/bin/ip route change 172.20.53.97 src 172.22.68.4 dev wg3914"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
