{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg0088";
      asn = 4242420088;
      e6 = "fe80::88:3";
      listen = 20088;
      endpoint = "jp01-peer.furry.lv:21888";
      publickey = "1fBfqOJnkf9blffCy5/DfQm+Sea3BkKikxUwOJA8CAs=";
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
  ];
}
