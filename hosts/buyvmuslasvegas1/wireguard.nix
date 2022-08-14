{ config, pkgs, ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  boot.kernel.sysctl = {
    "net.ipv4.conf.wg31111.rp_filter" = 0;
    "net.ipv4.conf.wg0253.rp_filter" = 0;
    "net.ipv4.conf.wg0549.rp_filter" = 0;
    "net.ipv4.conf.wg0826.rp_filter" = 0;
    "net.ipv4.conf.wg0864.rp_filter" = 0;
    "net.ipv4.conf.wg0927.rp_filter" = 0;
    "net.ipv4.conf.wg1123.rp_filter" = 0;
    "net.ipv4.conf.wg1586.rp_filter" = 0;
    "net.ipv4.conf.wg1817.rp_filter" = 0;
    "net.ipv4.conf.wg1877.rp_filter" = 0;
    "net.ipv4.conf.wg2032.rp_filter" = 0;
    "net.ipv4.conf.wg2189.rp_filter" = 0;
    "net.ipv4.conf.wg2464.rp_filter" = 0;
    "net.ipv4.conf.wg2688.rp_filter" = 0;
    "net.ipv4.conf.wg2980.rp_filter" = 0;
    "net.ipv4.conf.wg3021.rp_filter" = 0;
    "net.ipv4.conf.wg3088.rp_filter" = 0;
    "net.ipv4.conf.wg3308.rp_filter" = 0;
    "net.ipv4.conf.wg3918.rp_filter" = 0;
  };
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
    wg0549 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20549;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "las.usa.dn42.bb-pgqm.com:21888";
          publicKey = "SRokXOA/KtaiYlwQwpEiz6liGYzJY7CtMh9YIq3P3F0=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0826 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.196.0/32 dev wg0826"
        "${pkgs.iproute2}/bin/ip route change 172.23.196.0 src 172.22.68.5 dev wg0826"
      ];
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
    wg0864 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20864;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lax.dn42.christine.pp.ua:21888";
          publicKey = "mOQs7kIucUmSDXqRHvwfUxLAFkUDg9ssH5Gqn+6oj0s=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0927 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.77.33/32 dev wg0927"
        "${pkgs.iproute2}/bin/ip route change 172.21.77.33 src 172.22.68.5 dev wg0927"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20927;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lv1.dn42.liki.link:42424";
          publicKey = "CqA907Lo0J/qIPB5qRi5YcvPWK7VOG3fvjevVqKirFM=";
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
    wg1586 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.21.75.32/32 dev wg1586"
        "${pkgs.iproute2}/bin/ip route change 172.21.75.32 src 172.22.68.5 dev wg1586"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21586;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "lv.dn42.serversc.com:21888";
          publicKey = "9CO2NAA7vDqnkHP1ro4c0+zm6wEHmdaAF3JMShfTlkA=";
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
          endpoint = "4.us.kskb.eu.org:21888";
          publicKey = "dZzVdXbQPnWPpHk8QfW/p+MfGzAkMBuWpxEIXzQCggY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1877 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21877;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "suzuran.lilynet.work:21888";
          publicKey = "E/+f5HM2EEw7CV574nYj+51bRNJDOZ6C5BKSQBpMGgw=";
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
    wg2189 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22189;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us-lax.dn42.kuu.moe:42216";
          publicKey = "DIw4TKAQelurK10Sh1qE6IiDKTqL1yciI5ItwBgcHFA=";
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
    wg3021 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.33.161/32 dev wg3021"
        "${pkgs.iproute2}/bin/ip route change 172.23.33.161 src 172.22.68.5 dev wg3021"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23021;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "us1.dn42.ciplc.network:21888";
          publicKey = "qgTT/xzJWZH9iAN+8JW7nWgzk2/i1elposz7G7bnczY=";
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
          endpoint = "lax1-us.dn42.6700.cc:30012";
          publicKey = "QSAeFPotqFpF6fFe3CMrMjrpS5AL54AxWY2w1+Ot2Bo=";
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
