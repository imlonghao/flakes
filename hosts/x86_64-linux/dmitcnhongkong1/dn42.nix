{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg31111";
        asn = 4201271111;
        e6 = "fe80::aa:1111:1";
        listen = 31111;
        publickey = "2JHMpwkKaAMuMBrmapx9zqgGDIZOX9HZw5V2c1l66R8=";
      }
      {
        name = "wg0014";
        asn = 4242420014;
        e6 = "fe80::14:3";
        listen = 20014;
        endpoint = "hk.dn42.fxnet.top:21888";
        publickey = "y5D4KE+anbxbZ8p+JvzqDRv+PY/FPAu+TD26/9bmYC0=";
      }
      {
        name = "wg0202";
        e6 = "fe80::202:2";
        asn = 4242420202;
        listen = 20202;
        endpoint = "dn02.hk.hk.sdubs.vip:21888";
        publickey = "5YcwL93bhJqzhTxi9b1Z1ZRt2UfGVoP5jMA+UXma6HM=";
      }
      {
        name = "wg0222";
        l4 = "172.22.68.0";
        e4 = "172.20.142.2";
        asn = 4242420222;
        e6 = "fe80::222:2";
        listen = 20222;
        endpoint = "hk-1.dn42.saltwood.top:21888";
        publickey = "0E4goqfQFKQu852QAqVSRfp9Si9MoTj8IllFiDG7gUc=";
      }
      {
        name = "wg0298";
        e6 = "fe80::0298";
        asn = 4242420298;
        listen = 20298;
        endpoint = "node2.ox5.cc:21888";
        publickey = "dvw9vCSfpR7f93oBpaQyCyGaoo17RRm7InZbt0n1QnI=";
        presharedkey = "UcBb8jR3ERn09ncQLPp3ncfhUk/fV1+J5pjgdiisnww=";
      }
      {
        name = "wg0398";
        asn = 4242420398;
        e6 = "fe80::398";
        listen = 20398;
        endpoint = "hkl.dn42.boletus.icu:21888";
        publickey = "XD66eoHp06VmDUNFUguJeOY8gFLiLZ7Lkyz/WsMQSWU=";
      }
      {
        name = "wg0454";
        asn = 4242420454;
        e6 = "fe80::454:112";
        listen = 20454;
        endpoint = "dn42hk0.nedifinita.com:52310";
        publickey = "8auu/+HFce5JAexe1b5MDg+nh4vutQVlXd0kJySXVGc=";
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
        name = "wg0555";
        asn = 4242420555;
        e6 = "fe80::d555";
        listen = 20555;
        endpoint = "hk-01.node.dn42.0xptr.top:21888";
        publickey = "xin3e9mT1MVzPUVGG7pVIZ/FIkwOIGQNN2cVpCTLNS8=";
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
        name = "wg1117";
        asn = 4242421117;
        e6 = "fe80::1117";
        listen = 21117;
        endpoint = "hk01.dn42.yuyuko.com:21888";
        publickey = "gqwdC9p6jdSy80oRxdatr9QdSrNMLCvRMadaCeOBqDY=";
      }
      {
        name = "wg1166";
        asn = 4242421166;
        e6 = "fe80::1166";
        listen = 21166;
        endpoint = "hk.dn42.milu.moe:21888";
        publickey = "f9ZDh2U0UXxtEroHUYNWzaE6TZM3hhY3eLXQQpgkvBY=";
      }
      {
        name = "wg1331";
        asn = 4242421331;
        e6 = "fe80::1331";
        listen = 21331;
        endpoint = "apr1.hk.strexp.net:21888";
        publickey = "tk/rTyA7TsSg/wmF8FmgQOuPJPxYFoyJZauw6UVO8Hw=";
      }
      {
        name = "wg1534";
        listen = 21534;
        endpoint = "hk-hkg.factor2431.com:21888";
        publickey = "VncCNj0rfJ8xF4ms7yqvt+WzAS0ePC+pLiiG4FPPHkw=";
        asn = 4242421534;
        e6 = "fe80::1534";
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
        name = "wg1604";
        asn = 4242421604;
        e6 = "fe80::1604";
        listen = 21604;
        endpoint = "cn-hkg.nodes.libecho.top:21888";
        publickey = "T/sArG5+D8/IqJ3X39emADEKQEhg2Y+s/tytyfH7Wz8=";
      }
      {
        name = "wg1686";
        asn = 4242421686;
        e6 = "fe80::1686";
        listen = 21686;
        endpoint = "hk-1.dn42.guet.eu.org:21888";
        publickey = "D4MBIR+HsCPeEGuPg1YziRe1RgaG7jaiTw4wmV8XZUY=";
      }
      {
        name = "wg1733";
        asn = 4242421733;
        e6 = "fe80::1733";
        listen = 21733;
        endpoint = "hkg.entry.dn42.hk:21888";
        publickey = "rHUqrpHKeqJo2QpgG4fTU8B47XF8Bu51opKYfRwq3Rg=";
      }
      {
        name = "wg1772";
        listen = 21772;
        endpoint = "154.12.177.103:41888";
        publickey = "MwKtHYi3qWDRlpZuF6MNTHZuathA96J89GeF7INPvmw=";
        asn = 4242421772;
        e6 = "fe80::1772";
      }
      {
        name = "wg1816";
        listen = 21816;
        endpoint = "hkg.node.potat0.cc:21888";
        publickey = "Tv1+HniELrS4Br2i7oQgwqBJFXQKculsW8r+UOqQXH0=";
        asn = 4242421816;
        e6 = "fe80::1816";
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
        name = "wg2024";
        asn = 4242422024;
        e6 = "fe80::2024";
        listen = 22024;
        endpoint = "hkg02-cn.ecs.iyoroy-infra.top:21888";
        publickey = "bg+KnzVupBrOQntHFFVzvBx+3sqYVoyJRantT6m5fm8=";
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
        e6 = "fe80::2189:120";
        listen = 22189;
        endpoint = "hk-hkg.dn42.kuu.moe:44383";
        publickey = "OlUDuWkUI9pKNsNo7Vjf/GKKVSBslh9kmqjbeYA4+34=";
      }
      {
        name = "wg2279";
        listen = 22279;
        endpoint = "hk-hkg1.bb.mhr.hk:21888";
        publickey = "PUjqyQ3ATLp8Cxp3YFVQ44QLoZEpoPgdXsbMfXhDMRk=";
        asn = 4242422279;
        e6 = "fe80::2279";
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
        name = "wg3088";
        listen = 23088;
        endpoint = "hk1-hk.dn42.6700.cc:21888";
        publickey = "rBTH+JyZB0X/DkwHByrCjCojxBKr/kEOm1dTAFGHR1w=";
        asn = 4242423088;
        ipv6 = "fe80::abcd/64";
        e6 = "fe80::3088:192";
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
        name = "wg3310";
        asn = 4242423310;
        e6 = "fe80::1888:3310";
        listen = 23310;
        endpoint = "hkg01.edge.r1.tmpfs.dev:21888";
        publickey = "aC9pjzMWZhbA/sLPljUFGU1K28MSopHbKNj5yyv4uzg=";
      }
      {
        name = "wg3374";
        asn = 4242423374;
        e6 = "fe80::2999:225";
        listen = 23374;
        endpoint = "hk01.dn42.baka.pub:21888";
        publickey = "zcxhWeI3SrJtqlHuqdeNaCeWSwJIYOTjAraXm655+VY=";
      }
      {
        name = "wg3377";
        asn = 4242423377;
        e6 = "fe80::3377";
        listen = 23377;
        endpoint = "hk1.peer.dn42.leziblog.com:21888";
        publickey = "XaX6/G7EQbcjsrtlxNmDc/s/VSdTxtkBxZKB2JpWIHo=";
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
        name = "wg3797";
        listen = 23797;
        asn = 4242423797;
        e6 = "fe80::3797";
        endpoint = "hk-hkg1.rc.badaimweeb.me:50051";
        publickey = "4Kyabql4m5Aay43m0jToCyU9BPRa1aLYBWN6IBSaSW4=";
      }
      {
        name = "wg3845";
        asn = 4242423845;
        e6 = "fe80::114";
        listen = 23845;
        endpoint = "hkg1.dn42.aerodefense.co.uk:21888";
        publickey = "jR21mrHsYv4KHPrRgtPPTl4BNU2by6dRV110nUIVfU4=";
      }
      {
        name = "wg3914";
        asn = 4242423914;
        e6 = "fe80::ade0";
        listen = 23914;
        endpoint = "hk1.g-load.eu:21888";
        publickey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
      }
      {
        name = "wg3997";
        asn = 4242423997;
        e6 = "fe80::3997";
        listen = 23997;
        endpoint = "hk1.dn42.bitrate.studio:21888";
        publickey = "BwDwBx+r7zTrUZHdUeKsQFkEVEgx4iH13+0LQnCtpEE=";
      }
      {
        name = "wg3999";
        listen = 23999;
        endpoint = "hkg.node.cowgl.tech:31888";
        publickey = "mGGBczSVKW+7UKRquI2GkbKrfxiATv9r4uF5WTP+vWI=";
        asn = 4242423999;
        e4 = "172.22.144.64";
        e6 = "fe80::3999";
        l4 = "172.22.68.0";
        mpbgp = false;
      }
    ];
  };
}
