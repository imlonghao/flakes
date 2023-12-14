{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg0390"; listen = 20390; endpoint = "[2a01:4f9:c010:8f95::1]:51842"; publickey = "n07Sb5e0qF9OkeEobooTZceFbayIMAzpL7TLFUNo/n0="; asn = 4242420390; e6 = "fe80::c7d5:1377:6a6f:48b4"; }
    { name = "wg1816"; listen = 21816; endpoint = "no1.dn42.potat0.cc:21888"; publickey = "H6HdsuQsav9puKyo8SJaML0vPU/a2lLQjTRc7dmiqjs="; asn = 4242421816; e6 = "fe80::1816"; }
  ];
}
