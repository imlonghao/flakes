{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [{
    name = "wg1816";
    listen = 21816;
    endpoint = "no1.dn42.potat0.cc:21888";
    publickey = "H6HdsuQsav9puKyo8SJaML0vPU/a2lLQjTRc7dmiqjs=";
    asn = 4242421816;
    e6 = "fe80::1816";
  }];
}
