{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg64719"; listen = 64719; endpoint = "de-fra.dn42.lutoma.org:43039"; publickey = "pI9qB/y5L1iSOxFgam4uoBk2So+P52lAgYC3k8XS9zU="; asn = 64719; e4 = "172.22.119.1"; e6 = "fe80::acab"; l4 = "172.22.68.4"; }
    { name = "wg31111"; listen = 31111; publickey = "YnoqhBTjO0+2vj/1lXqzOmvKeCwZ4q3BJzNyxN/zQ00="; asn = 4201271111; e6 = "fe80::aa:1111:41"; }
    { name = "wg0197"; listen = 20197; endpoint = "himalia.dn42.n0emis.eu:21888"; publickey = "ObF+xGC6DdddJer0IUw6nzC0RqzeKWwEiQU0ieowzhg="; asn = 4242420197; e4 = "172.20.190.96"; e6 = "fe80::42:42:1"; l4 = "172.22.68.4"; }
    { name = "wg0377"; listen = 20377; endpoint = "de-fra1.zycname.eu.org:21888"; publickey = "ML5JataTUgcW7NYCbouYqZ8DJ+KGX2ugoSIWxM2lLRw="; asn = 4242420377; e6 = "fe80::0377"; }
    { name = "wg0458"; listen = 20458; endpoint = "eu-west1.nodes.huajinet.org:21888"; publickey = "J/EptroniSBNvzHhk0lQReRoHwV/m9vQo2l2CY69pXA="; asn = 4242420458; e6 = "fe80::0458"; }
    { name = "wg0499"; listen = 20499; endpoint = "138.201.54.47:41888"; publickey = "p4yaGWSl2p2Pe3GxUQ3OQREoKPqiSK3svc8+aHnuYzs="; asn = 4242420499; e4 = "172.23.33.65"; e6 = "fe80::499:1"; l4 = "172.22.68.4"; }
    { name = "wg0577"; listen = 20577; publickey = "SPfVzZHC6U+8oAJ0rd0foq0PH9xRYKGRVHLosV1WbXc="; asn = 4242420577; e6 = "fe80::577:1"; }
    { name = "wg0864"; listen = 20864; endpoint = "nue.dn42.christine.pp.ua:21888"; publickey = "ypRGDCaVyoIJFPkRDbXm/wo8liNcbsY3PkiGBqZJzUI="; asn = 4242420864; e6 = "fe80::864:3"; }
    { name = "wg1080"; listen = 21080; endpoint = "fra.peer.highdef.network:21888"; publickey = "oiSSSOMYxiiM0eQP9p8klwEfNn34hkNNv4S289WUciU="; asn = 4242421080; e6 = "fe80::117"; }
    { name = "wg1411"; listen = 21411; endpoint = "famfo.xyz:51888"; publickey = "mC1XpNNItKM/zl+RkhYOSFJODnkkE55gAPZQtrnNyDU="; asn = 4242421411; e6 = "fe80::1411:1"; }
    { name = "wg1592"; listen = 21592; endpoint = "de01.dn42.ca.melusfer.us:41888"; publickey = "7zViBU5dDWV3pxnIGX2ixQmXIgRwvmIW7qwmCgWctzc="; asn = 4242421592; e4 = "172.21.99.191"; e6 = "fe80::1592"; l4 = "172.22.68.4"; }
    { name = "wg1817"; listen = 21817; publickey = "Sxn9qXnzu3gSBQFZ0vCh5t5blUJYgD+iHlCCG2hexg4="; asn = 4242421817; e6 = "fe80::42:1817:a"; }
    { name = "wg2189"; listen = 22189; endpoint = "de-fra.dn42.kuu.moe:57353"; publickey = "FHp0OR4UpAS8/Ra0FUNffTk18soUYCa6NcvZdOgxY0k="; asn = 4242422189; e6 = "fe80::2189:e9"; }
    { name = "wg2331"; listen = 22331; endpoint = "lu208.dn42.williamgates.info:21888"; publickey = "c4AZZVNUzXCASWG96CKUpY+gQLdGwA1rbqkYCHXnW10="; asn = 4242422331; e6 = "fe80::2331"; }
    { name = "wg2458"; listen = 22458; endpoint = "nl-ams-a.nodes.pigeonhole.eu.org:51888"; publickey = "QJnmWUnPS9wKKkLHHuWBYMGAI20MH9OEo28O4qr5DV8="; asn = 4242422458; e6 = "fe80::2458"; }
    { name = "wg2717"; listen = 22717; endpoint = "nl.vm.whojk.com:23024"; publickey = "cokP4jFBH0TlBD/m3sWCpc9nADLOhzM2+lcjAb3ynFc="; asn = 4242422717; e6 = "fe80::2717"; }
    { name = "wg2923"; listen = 22923; endpoint = "p2p-node.de:51888"; publickey = "GD554w8JM8R2s0c/mR7sBbYy/zTP5GWWB+Zl1gx5GUk="; asn = 4242422923; e6 = "fe80::2923"; }
    { name = "wg2980"; listen = 22980; endpoint = "fra1.de.dn42.yuuta.moe:21888"; publickey = "GYEhSHmPD0pVX3xBKa7SAwnuCyMA2oOsaHBgFpPO4X4="; presharedkey = "iHxtuu7sFtvR/nsOA2m3T4Lt3w8P4VzvLKHWAm23a1w="; asn = 4242422980; ipv6 = "fe80::1888:4/64"; e6 = "fe80::2980"; }
    { name = "wg3035"; listen = 23035; endpoint = "de01.dn42.lare.cc:21888"; publickey = "OL2LE2feDsFV+fOC4vo4u/1enuxf3m2kydwGRE2rKVs="; asn = 4242423035; e6 = "fe80::3035:130"; }
    { name = "wg3088"; listen = 23088; endpoint = "fra1-de.dn42.6700.cc:21888"; publickey = "TWQhJYK+ynNz7A4GMAQSHAyUUKTnAYrBfWTzzjzhAFs="; asn = 4242423088; e6 = "fe80::3088:195"; }
    { name = "wg3396"; listen = 23396; endpoint = "uk1.dn42.theresa.cafe:21888"; publickey = "zhDkw8DNmH5spOWh12790/zPA9NKblr2taIDPM5G/g4="; asn = 4242423396; e6 = "fe80::3396"; }
    { name = "wg3814"; listen = 23814; endpoint = "193.77.181.233:51820"; publickey = "F+esDrnKGU1I9/vwvg2cx8hTLft9ui21uLZIBgDo81M="; asn = 4242423814; e4 = "172.20.43.65"; e6 = "fd21:5c0c:9b7e:4:3814::2"; l4 = "172.22.68.4"; mpbgp = false; ipv6 = "fd21:5c0c:9b7e:4:3814::1/80"; }
    { name = "wg3847"; listen = 23847; endpoint = "de-flk-dn42.0011.de:21888"; publickey = "b8jJ2n2CyAm3iGvVl95Rc9yINXqHd16y4OkW40zV0FQ="; asn = 4242423847; e6 = "fe80::42:3847:42:1888"; }
    { name = "wg3914"; listen = 23914; endpoint = "de2.g-load.eu:21888"; publickey = "B1xSG/XTJRLd+GrWDsB06BqnIq8Xud93YVh/LYYYtUY="; asn = 4242423914; e6 = "fe80::ade0"; }
  ];
}
