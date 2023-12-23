{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg1080"; listen = 21080; endpoint = "202.5.26.208:21888"; publickey = "gTSNP0p+Ok3gaw0mcB1yhuZ2obaoOUxW+jPI2KxGAkc="; asn = 4242421080; e6 = "fe80::1080:33"; } # dal.peer.highdef.network
  ];
}
