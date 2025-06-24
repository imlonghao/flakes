{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
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
