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
        name = "wg0070";
        asn = 4242420070;
        e6 = "fe80::0070:1";
        listen = 20070;
        endpoint = "jp.dn42.lie-kong.top:21888";
        publickey = "PA5hDpcgaKsYKUyI3lLMcYojivg5LRfBuyOSsKTq1mY=";
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
        name = "wg3035";
        asn = 4242423035;
        e6 = "fe80::3035:134";
        listen = 23035;
        endpoint = "jp01.dn42.lare.cc:21888";
        publickey = "oTPdRylNhX2O80e6rLejT9Fwzo7KWKZ7a3PUF4G9oEM=";
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
        endpoint = "tyo.node.cowgl.xyz:31888";
        publickey = "mMGGxtEqsagrx1Raw57C2H3Stl6ch/cUuF7y08eVgBE=";
        mpbgp = false;
      }
    ];
  };
}
