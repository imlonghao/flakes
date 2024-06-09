{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg1080";
      listen = 21080;
      endpoint = "202.5.26.208:21888";
      publickey = "gTSNP0p+Ok3gaw0mcB1yhuZ2obaoOUxW+jPI2KxGAkc=";
      asn = 4242421080;
      e6 = "fe80::1080:33";
    } # dal.peer.highdef.network
    {
      name = "wg1588";
      listen = 21588;
      endpoint = "us-dal01.dn42.tech9.io:59048";
      publickey = "iEZ71NPZge6wHKb6q4o2cvCopZ7PBDqn/b3FO56+Hkc=";
      asn = 4242421588;
      ipv6 = "fe80::100/64";
      e4 = "172.20.16.140";
      e6 = "fe80::1588";
      l4 = "172.22.68.0";
    }
  ];
}
