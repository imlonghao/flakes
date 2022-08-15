{ config, pkgs, self, ... }:
let
  wgPrivKey = (builtins.fromJSON (builtins.readFile "${self}/secrets/wireguard.json")).hetznerdefalkenstein1;
in
{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  boot.kernel.sysctl = {
    "net.ipv4.conf.wg64719.rp_filter" = 0;
    "net.ipv4.conf.wg31111.rp_filter" = 0;
    "net.ipv4.conf.wg0197.rp_filter" = 0;
    "net.ipv4.conf.wg0345.rp_filter" = 0;
    "net.ipv4.conf.wg0385.rp_filter" = 0;
    "net.ipv4.conf.wg0499.rp_filter" = 0;
    "net.ipv4.conf.wg0864.rp_filter" = 0;
    "net.ipv4.conf.wg1078.rp_filter" = 0;
    "net.ipv4.conf.wg1513.rp_filter" = 0;
    "net.ipv4.conf.wg1588.rp_filter" = 0;
    "net.ipv4.conf.wg1592.rp_filter" = 0;
    "net.ipv4.conf.wg1817.rp_filter" = 0;
    "net.ipv4.conf.wg2189.rp_filter" = 0;
    "net.ipv4.conf.wg2331.rp_filter" = 0;
    "net.ipv4.conf.wg2615.rp_filter" = 0;
    "net.ipv4.conf.wg2717.rp_filter" = 0;
    "net.ipv4.conf.wg2923.rp_filter" = 0;
    "net.ipv4.conf.wg2980.rp_filter" = 0;
    "net.ipv4.conf.wg3044.rp_filter" = 0;
    "net.ipv4.conf.wg3088.rp_filter" = 0;
    "net.ipv4.conf.wg3847.rp_filter" = 0;
    "net.ipv4.conf.wg3868.rp_filter" = 0;
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
    wg31111 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg0345 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.49.33/32 dev wg0345"
        "${pkgs.iproute2}/bin/ip route change 172.23.49.33 src 172.22.68.4 dev wg0345"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg0864 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20864;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "nue.dn42.christine.pp.ua:21888";
          publicKey = "ypRGDCaVyoIJFPkRDbXm/wo8liNcbsY3PkiGBqZJzUI=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1078 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.86.32/32 dev wg1078"
        "${pkgs.iproute2}/bin/ip route change 172.23.86.32 src 172.22.68.4 dev wg1078"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21078;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "dn42.pgnhd.moe:3959";
          publicKey = "72yTeL6AEAmWKNYGc14mYSjYU9qElYLSMzxaNhSua08=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1513 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21513;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "ayumu-muc.de.nodes.dn42.xkww3n.cyou:21888";
          publicKey = "PjS6RoBo4vcTPzQqpLeFkhkcvKSKJz6MeZfeGgGuYW8=";
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
    wg1817 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21817;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = "Sxn9qXnzu3gSBQFZ0vCh5t5blUJYgD+iHlCCG2hexg4=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2189 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22189;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de-fra.dn42.kuu.moe:57353";
          publicKey = "FHp0OR4UpAS8/Ra0FUNffTk18soUYCa6NcvZdOgxY0k=";
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
          endpoint = "lu208.dn42.williamgates.info:21888";
          publicKey = "c4AZZVNUzXCASWG96CKUpY+gQLdGwA1rbqkYCHXnW10=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2615 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22615;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "euhax6.dn42.oldtaoge.space:21888";
          publicKey = "RL4c63BimHwb6VNbo8k1IHDsIELp35pUF5kkzCz4LxA=";
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
          endpoint = "nl.vm.whojk.com:23024";
          publicKey = "cokP4jFBH0TlBD/m3sWCpc9nADLOhzM2+lcjAb3ynFc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2923 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22923;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "p2p-node.de:51888";
          publicKey = "GD554w8JM8R2s0c/mR7sBbYy/zTP5GWWB+Zl1gx5GUk=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2980 = {
      ips = [ "fe80::1888:4/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.4/32 peer 172.23.105.4/32 dev wg2980";
      privateKeyFile = config.sops.secrets.wireguard.path;
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
    wg3044 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23044;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "nl.dn42.ssssteve.one:21888";
          publicKey = "ighiBJss6sW+CZpMAzks13WVDud3VWrouPBHWJu9kDg=";
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
    wg3847 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23847;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "de-flk-dn42.0011.de:21888";
          publicKey = "b8jJ2n2CyAm3iGvVl95Rc9yINXqHd16y4OkW40zV0FQ=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3868 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23868;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "fra1.dn42.cooo.cool:21888";
          publicKey = "UFDPre74vbNAV+e2dvdeEWNqT4h8X8ryyIrNIGWWUzU=";
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
