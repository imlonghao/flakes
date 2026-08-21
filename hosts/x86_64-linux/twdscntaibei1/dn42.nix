{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg0028";
        listen = 20028;
        endpoint = "tpe1.edge.ngworks.org:51800";
        publickey = "xrI6PtNid+TDc/EWgYBZVfRRKI0qawfOyZ4LLYmqNTY=";
        asn = 4242420028;
        local_role = "peer";
        e6 = "fe80::28";
      }
      {
        name = "wg0454";
        asn = 4242420454;
        local_role = "customer";
        e6 = "fe80::454";
        listen = 20454;
        endpoint = "dn42d.nedifinita.com:21888";
        publickey = "8auu/+HFce5JAexe1b5MDg+nh4vutQVlXd0kJySXVGc=";
      }
      {
        name = "wg1733";
        asn = 4242421733;
        e6 = "fe80::1733";
        listen = 21733;
        endpoint = "tpe.entry.dn42.hk:21888";
        publickey = "kceZbHZekCVvlC8ZU+C3XZAe1WQ7T5vsi8Ec94+MMm8=";
      }
      {
        name = "wg2189";
        asn = 4242422189;
        local_role = "customer";
        e6 = "fe80::2189:179";
        listen = 22189;
        endpoint = "tw-txg.dn42.iedon.net:52252";
        publickey = "HVNrF2blJH57JsIOxvCOlNihoJDqqAcZeD3rlotRBig=";
      }
      {
        name = "wg2670";
        listen = 22670;
        endpoint = "tw1.dn42.mofu.party:21888";
        publickey = "35W3y1U1eRelEYpmlmUDsY8PH/VUPjMH12bBgR6G1C8=";
        asn = 4242422670;
        local_role = "peer";
        e6 = "fe80::2670";
      }
      {
        name = "wg3797";
        listen = 23797;
        asn = 4242423797;
        local_role = "peer";
        e6 = "fe80::3797";
        endpoint = "tw-tpe1.rc.badaimweeb.me:50054";
        publickey = "oV/BMBeChhH1Rrb7/IOUibsiEJltIfIUlbMudKaTmzQ=";
      }
      {
        name = "wg3999";
        asn = 4242423999;
        local_role = "customer";
        l4 = "172.22.68.12";
        e4 = "172.22.144.80";
        e6 = "fe80::3999";
        listen = 23999;
        endpoint = "txg.node.cowgl.tech:31888";
        publickey = "mGGBczSVKW+7UKRquI2GkbKrfxiATv9r4uF5WTP+vWI=";
        mpbgp = false;
      }
    ];
  };
}
