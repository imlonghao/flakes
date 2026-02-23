{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg0014";
        asn = 4242420014;
        e6 = "fe80::0014:1";
        listen = 20014;
        endpoint = "jp.dn42.fxnet.top:21888";
        publickey = "ixYWNm89pSNvvyr4x4IquXVaTEoJHZg/yXCJ6mj7W2g=";
      }
      {
        name = "wg0088";
        asn = 4242420088;
        e6 = "fe80::88:3";
        listen = 20088;
        endpoint = "jp01-peer.furry.lv:21888";
        publickey = "1fBfqOJnkf9blffCy5/DfQm+Sea3BkKikxUwOJA8CAs=";
      }
      {
        name = "wg0207";
        listen = 20207;
        endpoint = "router.tyo1.routedbits.com:51888";
        publickey = "Urnj0In2/ba5zBJ0+TvGN6/A3JFXZwWfJ3EVkc5A4Cs=";
        asn = 4242420207;
        e6 = "fe80::207";
      }
      {
        name = "wg0298";
        asn = 4242420298;
        e6 = "fe80::0298";
        listen = 20298;
        endpoint = "node5.ox5.cc:21888";
        publickey = "kYYvoqiavXIbli1p9OCwStnTLc0TRdRKBMsIQ7kVlDM=";
      }
      {
        name = "wg0398";
        asn = 4242420398;
        e6 = "fe80::398";
        listen = 20398;
        endpoint = "nrt.dn42.boletus.icu:21888";
        publickey = "QQecM/0eCbRu5TNdyRxGpJTCo6aGolMb0kZAqLH5Oho=";
      }
      {
        name = "wg1023";
        asn = 4242421023;
        e6 = "fe80::1023:2";
        listen = 21023;
        endpoint = "tyo-01.node.svc.moe:21888";
        publickey = "pv0bwaUm/ppI7Yaoi7w0qrXX5EW7Qo2njTSNG19AHgM=";
      }
      {
        name = "wg1024";
        asn = 4242421024;
        e6 = "fe80::1024";
        listen = 21024;
        endpoint = "osa.dn42.moesoft.org:21888";
        publickey = "fzFVoGbO+an6rH00yWkhISfHQEZeXINGElM9GFwSmGc=";
      }
      {
        name = "wg1117";
        asn = 4242421117;
        e6 = "fe80::1117";
        listen = 21117;
        endpoint = "jp01.dn42.yuyuko.com:21888";
        publickey = "vZXB25Od9elWU4RKWp42MWNJrNtxJFgdmBkyYH/8Sj8=";
      }
      {
        name = "wg1131";
        asn = 4242421131;
        e6 = "fe80::1131";
        listen = 21131;
        endpoint = "tokyo.japan.dn42.yuzu.im:21888";
        publickey = "7ZLEhruv0R7V9DUEv+BHLr5fszpp/B55aKFtVoIACno=";
      }
      {
        name = "wg1336";
        asn = 4242421336;
        e6 = "fe80::1336";
        listen = 21336;
        endpoint = "jp1.dn42.xeiu.top:21888";
        publickey = "eacDn4IjHBMavV9IeilwPmrVDoVyKBkNhgK6qUBskiM=";
      }
      {
        name = "wg1534";
        asn = 4242421534;
        e6 = "fe80::1534";
        listen = 21534;
        endpoint = "jp-tyo.factor2431.com:21888";
        publickey = "XYyk/uk3LTHk7vOqtDsDh/AcPtdT3qQptqhggzZCRio=";
      }
      {
        name = "wg1999";
        asn = 4242421999;
        e6 = "fe80::1999";
        listen = 21999;
        endpoint = "tyo1.dn42.luotianyi.sbs:21888";
        publickey = "vzCKl611U0MVeaIcNyb8gJgWk1p6HY6oHr1oE846Py8=";
      }
      {
        name = "wg2024";
        asn = 4242422024;
        e6 = "fe80::2024";
        listen = 22024;
        endpoint = "ipv4.tyo-jp.ecs.iyoroy-infra.top:21888";
        publickey = "Sh62ZCxnEcXyLq49mLP1jF4C2vWKhKMxjtZHxVUAQg4=";
      }
      {
        name = "wg2189";
        asn = 4242422189;
        e6 = "fe80::2189:ee";
        listen = 22189;
        endpoint = "jp-tyo.dn42.iedon.net:53538";
        publickey = "u2ImAJn9ewce9YHN6HaqrR3Sr4Xsy5UaaJOLJ7gkSzs=";
      }
      {
        name = "wg2279";
        listen = 22279;
        endpoint = "jp-nrt1.bb.mhr.hk:21888";
        publickey = "uowdto28iYS7tlmrhsrtpWu0XIl7iln4SQvwJRbLdz4=";
        asn = 4242422279;
        e6 = "fe80::2279";
      }
      {
        name = "wg3035";
        asn = 4242423035;
        e6 = "fe80::3035:134";
        listen = 23035;
        endpoint = "jp01.dn42.lare.cc:21888";
        publickey = "oTPdRylNhX2O80e6rLejT9Fwzo7KWKZ7a3PUF4G9oEM=";
      }
      {
        name = "wg3088";
        listen = 23088;
        endpoint = "tyo1-jp.dn42.6700.cc:21888";
        publickey = "b3gUz8an2+wSCvXAwuxGR7AnxKDUqqQMd1+LASo93R0=";
        asn = 4242423088;
        e6 = "fe80::3088:190";
      }
      {
        name = "wg3508";
        asn = 4242423508;
        e6 = "fe80::3508:100";
        listen = 23508;
        endpoint = "jp-tyo.dn42.ydkf.me:40644";
        publickey = "gMlu6MvagM0Bvywjv0KXkqHX5JI3zY0rXx1c8Xt2zzc=";
      }
      {
        name = "wg3797";
        listen = 23797;
        asn = 4242423797;
        e6 = "fe80::3797";
        endpoint = "jp-hnd1.rc.badaimweeb.me:50055";
        publickey = "OxNi54DlP+v7TImF0X5WFdDDZMJbQeBD9oY3Qa877HI=";
      }
      {
        name = "wg3997";
        asn = 4242423997;
        e6 = "fe80::3997";
        listen = 23997;
        endpoint = "jp1.dn42.bitrate.studio:21888";
        publickey = "wsjN0FgfZBFzSZQ66biOkYRtyQWWMFvX3ICOwj70D0U=";
      }
      {
        name = "wg3999";
        asn = 4242423999;
        e4 = "172.22.144.65";
        e6 = "fe80::1:3999";
        l4 = "172.22.68.10";
        listen = 23999;
        endpoint = "tyo.node.cowgl.tech:31888";
        publickey = "mMGGxtEqsagrx1Raw57C2H3Stl6ch/cUuF7y08eVgBE=";
        mpbgp = false;
      }
    ];
  };
}
