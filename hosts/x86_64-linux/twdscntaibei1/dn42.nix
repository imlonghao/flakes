{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg3797";
        listen = 23797;
        asn = 4242423797;
        e6 = "fe80::3797";
        endpoint = "tw-tpe1.rc.badaimweeb.me:50054";
        publickey = "oV/BMBeChhH1Rrb7/IOUibsiEJltIfIUlbMudKaTmzQ=";
      }
      {
        name = "wg3999";
        asn = 4242423999;
        l4 = "172.22.68.12";
        e4 = "172.22.144.64";
        e6 = "fe80::3999";
        listen = 23999;
        endpoint = "txg.node.cowgl.xyz:31888";
        publickey = "mGGBczSVKW+7UKRquI2GkbKrfxiATv9r4uF5WTP+vWI=";
        mpbgp = false;
      }
    ];
  };
}
