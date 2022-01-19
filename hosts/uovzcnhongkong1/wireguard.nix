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
          publicKey = "2JHMpwkKaAMuMBrmapx9zqgGDIZOX9HZw5V2c1l66R8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0341 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20341;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "jackynashome.tpddns.cn:21888";
          publicKey = "OWiVoIAfPwrc8BvmxL5QUOZY4PFhYOovf5gXmnvsGAg=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1588 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.16.145/32 dev wg1588"
        "${pkgs.iproute2}/bin/ip route change 172.20.16.145 src 172.22.68.3 dev wg1588"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21588;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "jp-tyo01.dn42.tech9.io:54012";
          publicKey = "unTYSat5YjkY+BY31Q9xLSfFhTUBvn3CiDCSZxbINVM=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg1817 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.77.33/32 dev wg1817"
        "${pkgs.iproute2}/bin/ip route change 172.22.77.33 src 172.22.68.3 dev wg1817"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21817;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "tw.kskb.eu.org:21818";
          publicKey = "jxCsSXtUSVjaP+eMWOyRsHg3JShQfBFEtyssMKWQaS8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2025 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.222.33/32 dev wg2025"
        "${pkgs.iproute2}/bin/ip route change 172.20.222.33 src 172.22.68.3 dev wg2025"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22025;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hkg1.servers.altk.org:21818";
          publicKey = "hIkTqemBb7E55I5JXDZ/5V9c/FLUI8BDUM1HHHcd63g=";
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
          endpoint = "aper.dneo.moeternet.com:21888";
          publicKey = "Yhn4+izxfHjrX2rTNzPCdjRKGzMrew6RE+dXQnpWwig=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2526 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.167.100/32 dev wg2526"
        "${pkgs.iproute2}/bin/ip route change 172.22.167.100 src 172.22.68.3 dev wg2526"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22526;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk.awsl.ee:51818";
          publicKey = "FDW5S+3nNS883Q5mKVwym0dwEYKF+nuQ1rPZ+sWVqgc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2717 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.22.66.66/32 dev wg2717"
        "${pkgs.iproute2}/bin/ip route change 172.22.66.66 src 172.22.68.3 dev wg2717"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22717;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "ncu.tw.dn42.hujk.eu.org:23022";
          publicKey = "ifN+KmnL5XLHG8nDi2nN9l26snGUP/1157p8mOSPE1c=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2980 = {
      ips = [ "fe80::1888:3/64" ];
      postSetup = "${pkgs.iproute2}/bin/ip addr add 172.22.68.3/32 peer 172.23.105.2/32 dev wg2980";
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22980;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "tyo1.jp.dn42.yuuta.moe:21888";
          publicKey = "nQ/5+M6MGsGJPWLQtEKBm8d1IzKZZZvIsOeTywhsH3Q=";
          presharedKey = "4MLgxuLpGDo/KWf01lLJnlg6etT+xDz+OpoqvVjmHEc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3618 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.51.98/32 dev wg3618"
        "${pkgs.iproute2}/bin/ip route change 172.20.51.98 src 172.22.68.3 dev wg3618"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23618;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "15.dyn.neo.jerryxiao.cc:50096";
          publicKey = "XhFVaLvuWT95gfI5e95bV84pESKenAgL5ulq+Q0KoSI=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3632 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.36.34/32 dev wg3632"
        "${pkgs.iproute2}/bin/ip route change 172.23.36.34 src 172.22.68.3 dev wg3632"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23632;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "jp0.dn42.melty.land:51824";
          publicKey = "uXeP5y2MP+XBcI7EU8LxqGS1r/Fu3vGIl3Q+r24J0UI=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3704 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23704;
      allowedIPsAsRoutes = false;
      peers = [
        {
          publicKey = "8xYXoU9lNuKyIMHQpB+RHxLER5xT0fIhWxp+F64Dqlc=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg3914 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.53.105/32 dev wg3914"
        "${pkgs.iproute2}/bin/ip route change 172.20.53.105 src 172.22.68.3 dev wg3914"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23914;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk1.g-load.eu:21888";
          publicKey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
  };
}
