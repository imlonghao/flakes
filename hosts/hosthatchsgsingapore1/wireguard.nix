{ config, pkgs, ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  boot.kernel.sysctl = {
    "net.ipv4.conf.wg2237.rp_filter" = 0;
    "net.ipv4.conf.wg2331.rp_filter" = 0;
    "net.ipv4.conf.wg2633.rp_filter" = 0;
    "net.ipv4.conf.wg2717.rp_filter" = 0;
    "net.ipv4.conf.wg3088.rp_filter" = 0;
  };
  networking.wireguard.interfaces = {
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
    wg2717 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22717;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sg.vm.whojk.com:24103";
          publicKey = "vCtn1DbfIiTgcMapuEGB/+/HnLeEPKPjxJbt/sjviTs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3088 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23088;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "sin1-sg.dn42.6700.cc:30010";
          publicKey = "rLuqS2ZQRk5ape3rHtBTXGbRbUP7lNYpufk3tt1P4z0=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
