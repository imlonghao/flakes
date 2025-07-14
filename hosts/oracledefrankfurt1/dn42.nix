{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg64719";
      listen = 64719;
      endpoint = "de-fra.dn42.lutoma.org:43039";
      publickey = "pI9qB/y5L1iSOxFgam4uoBk2So+P52lAgYC3k8XS9zU=";
      asn = 64719;
      e4 = "172.22.119.1";
      e6 = "fe80::acab";
      l4 = "172.22.68.4";
    }
    {
      name = "wg76190";
      listen = 36190;
      publickey = "uYzLhWuZRhAlhE+6KsqzclEZASInk/dDllfBAx5PnkQ=";
      asn = 76190;
      e4 = "172.23.235.1";
      e6 = "fe80::1299:e";
      l4 = "172.22.68.4";
      mpbgp = false;
    }
    {
      name = "wg31111";
      listen = 31111;
      publickey = "YnoqhBTjO0+2vj/1lXqzOmvKeCwZ4q3BJzNyxN/zQ00=";
      asn = 4201271111;
      e6 = "fe80::aa:1111:41";
    }
    {
      name = "wg0014";
      asn = 4242420014;
      e6 = "fe80::0014:10";
      listen = 20014;
      endpoint = "de.dn42.fxnet.top:21888";
      publickey = "qqib9JVb+Nugiv6VJeq5q0QsKv++9girnuOMgQSyi0o=";
    }
    {
      name = "wg0129";
      listen = 20129;
      endpoint = "de1.420129.xyz:21888";
      publickey = "N9rGceoiFcc/obnHrqMAmVlrb/E2Br55+doekTKwNF8=";
      asn = 4242420129;
      e6 = "fe80::129:2";
    }
    {
      name = "wg0197";
      listen = 20197;
      endpoint = "himalia.dn42.n0emis.eu:21888";
      publickey = "ObF+xGC6DdddJer0IUw6nzC0RqzeKWwEiQU0ieowzhg=";
      asn = 4242420197;
      e4 = "172.20.190.96";
      e6 = "fe80::42:42:1";
      l4 = "172.22.68.4";
    }
    {
      name = "wg0202";
      listen = 20202;
      endpoint = "dn05.fr.de.sdubs.vip:21888";
      publickey = "+CphUJP/d4amRiqmtTNtb/IURdhgb2BajgiAqpCl5C0=";
      asn = 4242420202;
      e6 = "fe80::202:5";
    }
    {
      name = "wg0207";
      listen = 20207;
      endpoint = "router.fra1.routedbits.com:51888";
      publickey = "FIk95vqIJxf2ZH750lsV1EybfeC9+V8Bnhn8YWPy/l8=";
      asn = 4242420207;
      e6 = "fe80::0207";
    }
    {
      name = "wg0392";
      listen = 20392;
      endpoint = "hackclub.app:21888";
      publickey = "BOI9J1hyFwlbjatNi9NUUMVnRXSOwBpb0f+Cgwl4p28=";
      asn = 4242420392;
      e6 = "fe80::392";
    }
    {
      name = "wg0458";
      listen = 20458;
      endpoint = "eu-west1.nodes.huajinet.org:21888";
      publickey = "J/EptroniSBNvzHhk0lQReRoHwV/m9vQo2l2CY69pXA=";
      asn = 4242420458;
      e6 = "fe80::0458";
    }
    {
      name = "wg0499";
      listen = 20499;
      endpoint = "138.201.54.47:41888";
      publickey = "p4yaGWSl2p2Pe3GxUQ3OQREoKPqiSK3svc8+aHnuYzs=";
      asn = 4242420499;
      e4 = "172.23.33.65";
      e6 = "fe80::499:1";
      l4 = "172.22.68.4";
    }
    {
      name = "wg0585";
      listen = 20585;
      endpoint = "de1.dn42.atolm.net:21888";
      publickey = "r5u1s5OY8ISJqv7oc1ZCA7RXMrJ/UOMgFdFVZ7qaPi4=";
      asn = 4242420585;
      e6 = "fe80::585";
    }
    {
      name = "wg0712";
      asn = 4242420712;
      e6 = "fe80::712";
      listen = 20712;
      endpoint = "dn42.ams.luotianyi.us:30105";
      publickey = "GQl6mSdQB6BOQR9pnhtFUIBrlXaPsjp16tRSbVE8rCw=";
    }
    {
      name = "wg1080";
      listen = 21080;
      endpoint = "fra.peer.highdef.network:21888";
      publickey = "oiSSSOMYxiiM0eQP9p8klwEfNn34hkNNv4S289WUciU=";
      asn = 4242421080;
      e6 = "fe80::117";
    }
    {
      name = "wg1240";
      listen = 21240;
      endpoint = "de-01.prefixlabs.net:21888";
      publickey = "ixeEBfac1BXpjNKbxcgL6Beg9HTgtmq6CjHIfMwNSDw=";
      asn = 4242421240;
      e6 = "fe80::1240:11";
    }
    {
      name = "wg1331";
      asn = 4242421331;
      e6 = "fe80::1331";
      listen = 21331;
      endpoint = "fra1.de.dn42.strexp.net:21888";
      publickey = "5RETqytZq0UP7t3Ui6OSwkacYUtZc651rozouXYdajY=";
    }
    {
      name = "wg1336";
      asn = 4242421336;
      e6 = "fe80::2:1336";
      listen = 21336;
      endpoint = "fra1.dn42.xeiu.top:21888";
      publickey = "Z5sN+emFAsZxrcpqcBnkww6X70FlHLRWkcuab4O7jzI=";
    }
    {
      name = "wg1411";
      listen = 21411;
      endpoint = "famfo.xyz:51888";
      publickey = "mC1XpNNItKM/zl+RkhYOSFJODnkkE55gAPZQtrnNyDU=";
      asn = 4242421411;
      e6 = "fe80::1411:1";
    }
    {
      name = "wg1592";
      listen = 21592;
      endpoint = "de01.dn42.ca.melusfer.us:41888";
      publickey = "7zViBU5dDWV3pxnIGX2ixQmXIgRwvmIW7qwmCgWctzc=";
      asn = 4242421592;
      e4 = "172.21.99.191";
      e6 = "fe80::1592";
      l4 = "172.22.68.4";
    }
    {
      name = "wg1771";
      listen = 21771;
      endpoint = "frank1.exploro.one:32615";
      publickey = "FPdZR0zq5z2U8nmvN28Y5VnURyCmECqPXqmadM0U9jk=";
      asn = 4242421771;
      e6 = "fe80::8572:7797:4bfd:26b3";
    }
    {
      name = "wg1816";
      listen = 21816;
      endpoint = "fra.node.potat0.cc:21888";
      publickey = "H6HdsuQsav9puKyo8SJaML0vPU/a2lLQjTRc7dmiqjs=";
      asn = 4242421816;
      e6 = "fe80::1816";
    }
    {
      name = "wg1999";
      asn = 4242421999;
      e6 = "fe80::1999";
      listen = 21999;
      endpoint = "fra1.dn42.luotianyi.sbs:21888";
      publickey = "3zIlkokGMnHgL0VrLxySZ45ziIOzEMldXQH/LMe1PAk=";
    }
    {
      name = "wg2092";
      listen = 22092;
      endpoint = "de0.dn42.pebkac.gr:51888";
      publickey = "g4MJv6qMPwbffxNjUKmIa5Yhf5ZzRqjIMzMHCSiFQgs=";
      asn = 4242422092;
      e6 = "fe80::ffff:2092";
    }
    {
      name = "wg2164";
      listen = 22164;
      endpoint = "de1.dn42.izm.im:21888";
      publickey = "OW3p16NOVEtm6/YrLu/ZpJon5ZKFHtdv1WImR2wwzW0=";
      asn = 4242422164;
      e6 = "fe80::2164";
    }
    {
      name = "wg2189";
      listen = 22189;
      endpoint = "de-fra.dn42.kuu.moe:57353";
      publickey = "FHp0OR4UpAS8/Ra0FUNffTk18soUYCa6NcvZdOgxY0k=";
      asn = 4242422189;
      e6 = "fe80::2189:e9";
    }
    {
      name = "wg2308";
      listen = 22308;
      endpoint = "de-fra1.dn42.mirsal.fr:21888";
      publickey = "iXu4yUw4w8/+hEHsOoQg26lByH8FAStv2pUnA0IeeXw=";
      presharedkey = "SFSwgV64PmlmCmzOgXnPBKbh9ltQJYPOPdQUEL3UIRw=";
      asn = 4242422308;
      e6 = "fe80::2308";
    }
    {
      name = "wg2331";
      listen = 22331;
      endpoint = "lu208.dn42.williamgates.info:21888";
      publickey = "c4AZZVNUzXCASWG96CKUpY+gQLdGwA1rbqkYCHXnW10=";
      asn = 4242422331;
      e6 = "fe80::2331";
    }
    {
      name = "wg2458";
      listen = 22458;
      endpoint = "nl-ams-a.nodes.pigeonhole.eu.org:51888";
      publickey = "QJnmWUnPS9wKKkLHHuWBYMGAI20MH9OEo28O4qr5DV8=";
      asn = 4242422458;
      e6 = "fe80::2458";
    }
    {
      name = "wg2575";
      asn = 4242422575;
      e6 = "fe80::2575:6";
      listen = 22575;
      endpoint = "zrh2-ch.androw.eu:21888";
      publickey = "iXi9Hy4UsEsafmI50u7N5pi5tK+t/X6VdGE8b8GJIXg=";
    }
    {
      name = "wg2601";
      asn = 4242422601;
      e6 = "fe80::42:2601:31:1";
      listen = 22601;
      endpoint = "dn42-de-fra1.burble.com:21888";
      publickey = "wdNV+4kcy5HZBGXWro1Zq2SoIiQPhg2G/vY+eC42QhQ=";
    }
    {
      name = "wg2717";
      listen = 22717;
      endpoint = "nl.vm.whojk.com:23024";
      publickey = "cokP4jFBH0TlBD/m3sWCpc9nADLOhzM2+lcjAb3ynFc=";
      asn = 4242422717;
      e6 = "fe80::2717";
    }
    {
      name = "wg2923";
      listen = 22923;
      endpoint = "p2p-node.de:51888";
      publickey = "GD554w8JM8R2s0c/mR7sBbYy/zTP5GWWB+Zl1gx5GUk=";
      asn = 4242422923;
      e6 = "fe80::2923";
    }
    {
      name = "wg2980";
      listen = 22980;
      endpoint = "fra1.de.dn42.yuuta.moe:21888";
      publickey = "GYEhSHmPD0pVX3xBKa7SAwnuCyMA2oOsaHBgFpPO4X4=";
      presharedkey = "iHxtuu7sFtvR/nsOA2m3T4Lt3w8P4VzvLKHWAm23a1w=";
      asn = 4242422980;
      ipv6 = "fe80::1888:4/64";
      e6 = "fe80::2980";
    }
    {
      name = "wg3035";
      listen = 23035;
      endpoint = "de01.dn42.lare.cc:21888";
      publickey = "OL2LE2feDsFV+fOC4vo4u/1enuxf3m2kydwGRE2rKVs=";
      asn = 4242423035;
      e6 = "fe80::3035:130";
    }
    {
      name = "wg3177";
      listen = 23177;
      endpoint = "95.130.6.48:51820";
      publickey = "lCegAi9aFb06Wt1jlzmDfXjQkPhV7PvqhneWeS7ETVs=";
      asn = 4242423177;
      l4 = "172.22.68.0";
      e4 = "172.23.118.97";
      e6 = "fd21:5c0c:9b7e:4:3177::2";
      presharedkey = "uoYHaMxujgsFhdXkzlgf1AVAXYCw7v4h4q+IrZmqxkU=";
      ipv6 = "fd21:5c0c:9b7e:4:3177::1/80";
    }
    {
      name = "wg3377";
      asn = 4242423377;
      e6 = "fe80::3377";
      listen = 23377;
      endpoint = "de1.peer.dn42.leziblog.com:21888";
      publickey = "Kd5+CvZW3NRvUXpbdqGFt85VzMyReBtnVeDVXae06Qg=";
    }
    {
      name = "wg3814";
      listen = 23814;
      endpoint = "193.77.181.233:51820";
      publickey = "F+esDrnKGU1I9/vwvg2cx8hTLft9ui21uLZIBgDo81M=";
      asn = 4242423814;
      e4 = "172.20.43.65";
      e6 = "fd21:5c0c:9b7e:4:3814::2";
      l4 = "172.22.68.4";
      mpbgp = false;
      ipv6 = "fd21:5c0c:9b7e:4:3814::1/80";
    }
    {
      name = "wg3914";
      listen = 23914;
      endpoint = "de2.g-load.eu:21888";
      publickey = "B1xSG/XTJRLd+GrWDsB06BqnIq8Xud93YVh/LYYYtUY=";
      asn = 4242423914;
      e6 = "fe80::ade0";
    }
    {
      name = "wg3999";
      listen = 23999;
      endpoint = "ams.node.cowgl.xyz:31888";
      publickey = "sHPUV74X+hqUK5wFj3m5kCga0rlPCxImUBwZ/oLiEn4=";
      asn = 4242423999;
      e6 = "fe80::3:3999";
      e4 = "172.22.144.67";
      l4 = "172.22.68.0";
      mpbgp = false;
    }
  ];
}
