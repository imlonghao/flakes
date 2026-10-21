{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg0078";
        listen = 20078;
        endpoint = "us01.tes286.top:21888";
        publickey = "7Tg2GpJ2VvlHrLgBV5YJHgEZm6B7h0cj2zGfxiAvb2A=";
        asn = 4242420078;
        local_role = "peer";
        e6 = "fe80::78";
      }
      {
        name = "wg0202";
        listen = 20202;
        endpoint = "64.44.157.153:21888";
        publickey = "BmeHi2lwxF0sX0w9IT5qk7q9A+deonRdN3XqnOpzvCw=";
        asn = 4242420202;
        local_role = "peer";
        e6 = "fe80::202:6";
      } # dn06.tx.us.sdubs.vip
      {
        name = "wg0504";
        listen = 20504;
        endpoint = "[2600:1700:8070:d400::1]:51837";
        publickey = "E65T8X/gDkR1epaDlrfWiUzEjEr7WdCenfxvin68fUE=";
        asn = 4242420504;
        local_role = "peer";
        e6 = "fe80::504";
      }
      {
        name = "wg1080";
        listen = 21080;
        endpoint = "202.5.26.208:21888";
        publickey = "gTSNP0p+Ok3gaw0mcB1yhuZ2obaoOUxW+jPI2KxGAkc=";
        asn = 4242421080;
        local_role = "customer";
        e6 = "fe80::1080:33";
      } # dal.peer.highdef.network
      {
        name = "wg1588";
        listen = 21588;
        endpoint = "us-dal01.dn42.tech9.io:59048";
        publickey = "iEZ71NPZge6wHKb6q4o2cvCopZ7PBDqn/b3FO56+Hkc=";
        asn = 4242421588;
        local_role = "customer";
        ipv6 = "fe80::100/64";
        e4 = "172.20.16.140";
        e6 = "fe80::1588";
        l4 = "172.22.68.0";
      }
      {
        name = "wg2670";
        listen = 22670;
        endpoint = "us1.dn42.mofu.party:21888";
        publickey = "wQsa3S9uxGRoO8vwEit5vM/fIehJJdkZJRhadgiN60g=";
        asn = 4242422670;
        local_role = "peer";
        e6 = "fe80::2670";
        mtu = 1380;
      }
    ];
  };
}
