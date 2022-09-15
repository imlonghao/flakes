{ config, pkgs, ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  boot.kernel.sysctl = {
    "net.ipv4.conf.wg31111.rp_filter" = 0;
    "net.ipv4.conf.wg0341.rp_filter" = 0;
    "net.ipv4.conf.wg0549.rp_filter" = 0;
    "net.ipv4.conf.wg0603.rp_filter" = 0;
    "net.ipv4.conf.wg0831.rp_filter" = 0;
    "net.ipv4.conf.wg1588.rp_filter" = 0;
    "net.ipv4.conf.wg1816.rp_filter" = 0;
    "net.ipv4.conf.wg1817.rp_filter" = 0;
    "net.ipv4.conf.wg2025.rp_filter" = 0;
    "net.ipv4.conf.wg2189.rp_filter" = 0;
    "net.ipv4.conf.wg2399.rp_filter" = 0;
    "net.ipv4.conf.wg2464.rp_filter" = 0;
    "net.ipv4.conf.wg2526.rp_filter" = 0;
    "net.ipv4.conf.wg2717.rp_filter" = 0;
    "net.ipv4.conf.wg2923.rp_filter" = 0;
    "net.ipv4.conf.wg2980.rp_filter" = 0;
    "net.ipv4.conf.wg3299.rp_filter" = 0;
    "net.ipv4.conf.wg3618.rp_filter" = 0;
    "net.ipv4.conf.wg3632.rp_filter" = 0;
    "net.ipv4.conf.wg3704.rp_filter" = 0;
    "net.ipv4.conf.wg3868.rp_filter" = 0;
    "net.ipv4.conf.wg3914.rp_filter" = 0;
  };
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
    wg0549 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20549;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hkg.hkg.dn42.bb-pgqm.com:21888";
          publicKey = "jtE83RMoN49bs8TOetxrGdzqywz2BI+uT1qJrGI7GVU=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg0603 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.23.7.65/32 dev wg0603"
        "${pkgs.iproute2}/bin/ip route change 172.23.7.65 src 172.22.68.3 dev wg0603"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 20603;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk02.nodes.mol.moe:21818";
          publicKey = "wNNbJyoFBrlpq53p61Ur8V2RNfS3U7KADlK7he64qRk=";
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
          endpoint = "hk.dn42.tms.im:21888";
          publicKey = "KlZg3oOjQsaQ0dNkUgHCKyOqULw8+u+llo97X1w5mV4=";
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
    wg1816 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 21816;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "jp1.dn42.potat0.cc:21818";
          publicKey = "Tv1+HniELrS4Br2i7oQgwqBJFXQKculsW8r+UOqQXH0=";
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
    wg2189 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22189;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "jp-tyo.dn42.kuu.moe:47568";
          publicKey = "TNmCdvH0DuPX0xxS6DPHw/2v3ojLa5kXIT/Z4Tpx+GY=";
          allowedIPs = [ "10.0.0.0/8" "172.20.0.0/14" "172.31.0.0/16" "fe80::/64" "fd00::/8" ];
        }
      ];
    };
    wg2399 = {
      ips = [ "fe80::1888/64" ];
      postSetup = [
        "${pkgs.iproute2}/bin/ip addr add 172.22.68.0/32 peer 172.20.222.128/32 dev wg2399"
        "${pkgs.iproute2}/bin/ip route change 172.20.222.128 src 172.22.68.3 dev wg2399"
      ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22399;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "112.213.124.196:21888";
          publicKey = "A1HIKpYTO2vV8af3Fk/9wreY+W05f0HxlenN60CNnTY=";
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
    wg2923 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 22923;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "gaylord-hkg.de:51888";
          publicKey = "MCLjwWmqnsQ9DoXdaNRfnuz+PE4y1J20l3Ag2y4Qk3w=";
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
    wg3299 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23299;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk1.ts2.online:21888";
          publicKey = "792War0IaILIGvxDym4rXZemGvh5mp4l3Rx5NwC2K2U=";
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
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23632;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "achacha.link.melty.land:21888";
          publicKey = "7t0RGOTU6KTNMp+dz1jmnsZDccXp8EQ6p9J6ZbgJkQQ=";
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
    wg3868 = {
      ips = [ "fe80::1888/64" ];
      privateKeyFile = config.sops.secrets.wireguard.path;
      listenPort = 23868;
      allowedIPsAsRoutes = false;
      peers = [
        {
          endpoint = "hk2.dn42.cooo.cool:21888";
          publicKey = "vmYyNK+JvwVQfUJ7sXR3BeUEOw2KAi/+iiKlQ2YDkxc=";
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
