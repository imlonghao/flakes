{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg1604";
      listen = 21604;
      endpoint = "ru-mos.nodes.libecho.top:21888";
      publickey = "1Gh8MJZpPk9R10eCUWgd9Sw7fA6P3FPn9n5JnBRi10U=";
      asn = 4242421604;
      e6 = "fe80::1604";
    }
  ];
}
