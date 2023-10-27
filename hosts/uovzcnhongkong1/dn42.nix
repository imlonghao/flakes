{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg31111";
      asn = 4201271111;
      e6 = "fe80::aa:1111:1";
      listen = 31111;
      publickey = "2JHMpwkKaAMuMBrmapx9zqgGDIZOX9HZw5V2c1l66R8=";
    }
    {
      name = "wg0458";
      asn = 4242420458;
      e6 = "fe80::0458";
      listen = 20458;
      endpoint = "hk1.nodes.huajinet.org:21888";
      publickey = "WmKjRCtf9ZlIDkSuEOrjk5B7YdRZNGhhlbfz2waDAgQ=";
    }
    {
      name = "wg0549";
      asn = 4242420549;
      e6 = "fe80::549:3441:0:1";
      listen = 20549;
      endpoint = "hkg.dn42.bb-pgqm.com:21888";
      publickey = "jtE83RMoN49bs8TOetxrGdzqywz2BI+uT1qJrGI7GVU=";
    }
    {
      name = "wg0803";
      asn = 4242420803;
      e6 = "fe80::0803";
      listen = 20803;
      endpoint = "hk.billchen.bid:21888";
      publickey = "+TkKvF5J4fd8KX0I9hCBTS7666GEEHlRUinQdIgEJSU=";
    }
    {
      name = "wg0831";
      asn = 4242420831;
      e6 = "fe80::0831";
      listen = 20831;
      endpoint = "hk.dn42.tms.im:21888";
      publickey = "KlZg3oOjQsaQ0dNkUgHCKyOqULw8+u+llo97X1w5mV4=";
    }
    {
      name = "wg1588";
      l4 = "172.22.68.3";
      e4 = "172.20.16.145";
      asn = 4242421588;
      e6 = "fe80::1588";
      listen = 21588;
      endpoint = "jp-tyo01.dn42.tech9.io:54012";
      publickey = "unTYSat5YjkY+BY31Q9xLSfFhTUBvn3CiDCSZxbINVM=";
    }
    {
      name = "wg1816";
      asn = 4242421816;
      e6 = "fe80::1816";
      listen = 21816;
      endpoint = "jp1.dn42.potat0.cc:21888";
      publickey = "Tv1+HniELrS4Br2i7oQgwqBJFXQKculsW8r+UOqQXH0=";
    }
    {
      name = "wg1817";
      l4 = "172.22.68.3";
      e4 = "172.22.77.33";
      asn = 4242421817;
      e6 = "fe80::42:1817:1";
      listen = 21817;
      endpoint = "tw.kskb.eu.org:21818";
      publickey = "jxCsSXtUSVjaP+eMWOyRsHg3JShQfBFEtyssMKWQaS8=";
    }
    {
      name = "wg2025";
      l4 = "172.22.68.3";
      e4 = "172.20.222.33";
      asn = 4242422025;
      e6 = "fe80::2025";
      listen = 22025;
      endpoint = "hkg1.servers.altk.org:21818";
      publickey = "hIkTqemBb7E55I5JXDZ/5V9c/FLUI8BDUM1HHHcd63g=";
    }
    {
      name = "wg2189";
      asn = 4242422189;
      e6 = "fe80::2189:ee";
      listen = 22189;
      endpoint = "jp-tyo.dn42.kuu.moe:47568";
      publickey = "TNmCdvH0DuPX0xxS6DPHw/2v3ojLa5kXIT/Z4Tpx+GY=";
    }
    { name = "wg2279"; listen = 22279; endpoint = "hkg-pop.moohric.com:21888"; publickey = "Ok3AoQIX0k/sxlOvGOJA1I+ELlAtiW9cSRTcf+i1Ikc="; asn = 4242422279; e4 = "172.23.77.200"; e6 = "fe80::abcd:200"; l4 = "172.22.68.0"; }
    {
      name = "wg2398";
      l4 = "172.22.68.3";
      e4 = "172.23.33.193";
      asn = 4242422398;
      e6 = "fe80::2399:1";
      listen = 22398;
      endpoint = "hk-hkg.nodes.yuzhen.network:21888";
      publickey = "YZHK/OEotkWSBrX3WZMrHUMQviLGzTfexsXz2R9clH4=";
    }
    {
      name = "wg2399";
      l4 = "172.22.68.3";
      e4 = "172.20.222.128";
      asn = 4242422399;
      e6 = "fe80::adc5";
      listen = 22399;
      endpoint = "112.213.124.196:21888";
      publickey = "A1HIKpYTO2vV8af3Fk/9wreY+W05f0HxlenN60CNnTY=";
    }
    {
      name = "wg2458";
      asn = 4242422458;
      e6 = "fe80::2458";
      listen = 22458;
      endpoint = "cn-hkg-a.nodes.pigeonhole.eu.org:51888";
      publickey = "9O4ABGmh+EXPnOynhW60aByE3qorcV7UsAC9n55g6CQ=";
    }
    {
      name = "wg2464";
      asn = 4242422464;
      e6 = "fe80::2464";
      listen = 22464;
      endpoint = "aper.dneo.moeternet.com:21888";
      publickey = "Yhn4+izxfHjrX2rTNzPCdjRKGzMrew6RE+dXQnpWwig=";
    }
    {
      name = "wg2717";
      l4 = "172.22.68.3";
      e4 = "172.22.66.66";
      asn = 4242422717;
      e6 = "fe80::104:50:2030";
      listen = 22717;
      endpoint = "ncu.tw.dn42.hujk.eu.org:23022";
      publickey = "ifN+KmnL5XLHG8nDi2nN9l26snGUP/1157p8mOSPE1c=";
    }
    {
      name = "wg2923";
      asn = 4242422923;
      e6 = "fe80::2925";
      listen = 22923;
      endpoint = "herzstein.mk16.de:51888";
      publickey = "MCLjwWmqnsQ9DoXdaNRfnuz+PE4y1J20l3Ag2y4Qk3w=";
    }
    {
      name = "wg2980";
      ipv6 = "fe80::1888:3/64";
      l4 = "172.22.68.3";
      ipv4 = "172.22.68.3";
      e4 = "172.23.105.2";
      asn = 4242422980;
      e6 = "fe80::2980";
      listen = 22980;
      endpoint = "tyo1.jp.dn42.yuuta.moe:21888";
      publickey = "nQ/5+M6MGsGJPWLQtEKBm8d1IzKZZZvIsOeTywhsH3Q=";
      presharedkey = "4MLgxuLpGDo/KWf01lLJnlg6etT+xDz+OpoqvVjmHEc=";
    }
    {
      name = "wg3299";
      asn = 4242423299;
      e6 = "fe80::3:3299";
      listen = 23299;
      endpoint = "hk1.ts2.online:21888";
      publickey = "792War0IaILIGvxDym4rXZemGvh5mp4l3Rx5NwC2K2U=";
    }
    {
      name = "wg3618";
      asn = 4242423618;
      e6 = "fe80::3618";
      listen = 23618;
      endpoint = "05.dyn.neo.jerryxiao.cc:50107";
      publickey = "XhFVaLvuWT95gfI5e95bV84pESKenAgL5ulq+Q0KoSI=";
    }
    {
      name = "wg3632";
      asn = 4242423632;
      e6 = "fe80::3632";
      listen = 23632;
      endpoint = "achacha.link.melty.land:21888";
      publickey = "7t0RGOTU6KTNMp+dz1jmnsZDccXp8EQ6p9J6ZbgJkQQ=";
    }
    {
      name = "wg3704";
      asn = 4242423704;
      e6 = "fe80::3704";
      listen = 23704;
      publickey = "8xYXoU9lNuKyIMHQpB+RHxLER5xT0fIhWxp+F64Dqlc=";
    }
    {
      name = "wg3914";
      l4 = "172.22.68.3";
      e4 = "172.20.53.105";
      asn = 4242423914;
      e6 = "fe80::ade0";
      listen = 23914;
      endpoint = "hk1.g-load.eu:21888";
      publickey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
    }
  ];
}
