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
          publicKey = "2FSX+6N/PwfipN/jXMj++4mabFQj25MXDy51mnnz3AA=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0247 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.250.81/32 dev wg0247"
        "${pkgs.iproute2}/bin/ip route change 172.23.250.81 src 172.22.68.1 dev wg0247"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20247;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us1.dn42.as141776.net:41888";
          publicKey = "tRRiOqYhTsygV08ltrWtMkfJxCps1+HUyN4tb1J7Yn4=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0262 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.114.97/32 dev wg0262"
        "${pkgs.iproute2}/bin/ip route change 172.22.114.97 src 172.22.68.1 dev wg0262"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20262;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "iad0.dn42.mtzfederico.com:21888";
          publicKey = "GggTJ5B5ypZszhBU+E5DmKChwTnjzif1ZbX+yXP1mH8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1080 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.229.123/32 dev wg1080"
        "${pkgs.iproute2}/bin/ip route change 172.20.229.123 src 172.22.68.1 dev wg1080"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21080;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "dn42-us-nyc02.jlu5.com:21888";
          publicKey = "YrlNsVP9bbTqNuNyQ/MVFzulZKNW5vMaDMzHVFNXSSE=";
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
          endpoint = "nyc.dneo.moeternet.com:21888";
          publicKey = "MLVJrwrph6d0VqrAq8/rkhbkG+mrQNytqmwrNgk2qFs=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2547 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.76.190/32 dev wg2547"
        "${pkgs.iproute2}/bin/ip route change 172.22.76.190 src 172.22.68.1 dev wg2547"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22547;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "virmach-ny1g.lantian.pub:21888";
          publicKey = "a+zL2tDWjwxBXd2bho2OjR/BEmRe2tJF9DHFmZIE+Rk=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3088 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.100.194/32 dev wg3088"
        "${pkgs.iproute2}/bin/ip route change 172.21.100.194 src 172.22.68.1 dev wg3088"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 42050;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "nyc1-us.dn42.6700.cc:21888";
          publicKey = "wAI2D+0GeBnFUqm3xZsfvVlfGQ5iDWI/BykEBbkc62c=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3914 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.53.98/32 dev wg3914"
        "${pkgs.iproute2}/bin/ip route change 172.20.53.98 src 172.22.68.1 dev wg3914"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us2.g-load.eu:21888";
          publicKey = "6Cylr9h1xFduAO+5nyXhFI1XJ0+Sw9jCpCDvcqErF1s=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
