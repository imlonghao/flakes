{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg1816"; listen = 21816; endpoint = "no1.dn42.potat0.cc:21888"; publickey = "H6HdsuQsav9puKyo8SJaML0vPU/a2lLQjTRc7dmiqjs="; asn = 4242421816; e6 = "fe80::1816"; }
    { name = "wg2330"; listen = 22330; endpoint = "osl01.kn.node.argonauts.xyz:51888"; publickey = "POZ2ZRRPbQtfcb1d0eiNeKlBVqJiYFQ4/naY/xfkfDQ="; asn = 4242422330; e6 = "fe80::2330:1"; }
  ];
}
