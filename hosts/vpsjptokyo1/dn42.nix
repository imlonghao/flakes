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
      name = "wg2189";
      asn = 4242422189;
      e6 = "fe80::2189:ee";
      listen = 22189;
      endpoint = "jp-tyo.dn42.iedon.net:53538";
      publickey = "u2ImAJn9ewce9YHN6HaqrR3Sr4Xsy5UaaJOLJ7gkSzs=";
    }
  ];
}
