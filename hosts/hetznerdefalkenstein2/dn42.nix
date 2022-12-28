{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg31111"; listen = 31111; publickey = "YnoqhBTjO0+2vj/1lXqzOmvKeCwZ4q3BJzNyxN/zQ00="; asn = 4201271111; e6 = "fe80::aa:1111:41"; }
    { name = "wg0361"; listen = 20361; endpoint = "nl-alk1.svr.xtexx.ml:10307"; publickey = "yaLBtUxByJE3151yUDS5K2u7ejHM/aPJj2bzYqYZygI="; asn = 4242420361; e6 = "fe80::0361"; }
    { name = "wg0458"; listen = 20458; endpoint = "eu-west1.nodes.huajinet.org:21888"; publickey = "J/EptroniSBNvzHhk0lQReRoHwV/m9vQo2l2CY69pXA="; asn = 4242420458; e6 = "fe80::0458"; }
    { name = "wg0864"; listen = 20864; endpoint = "nue.dn42.christine.pp.ua:21888"; publickey = "ypRGDCaVyoIJFPkRDbXm/wo8liNcbsY3PkiGBqZJzUI="; asn = 4242420864; e6 = "fe80::864:3"; }
    { name = "wg1080"; listen = 21080; endpoint = "fra.peer.highdef.network:21888"; publickey = "oiSSSOMYxiiM0eQP9p8klwEfNn34hkNNv4S289WUciU="; asn = 4242421080; e6 = "fe80::117"; }
    { name = "wg1513"; listen = 21513; endpoint = "ayumu-muc.de.nodes.dn42.xkww3n.cyou:21888"; publickey = "PjS6RoBo4vcTPzQqpLeFkhkcvKSKJz6MeZfeGgGuYW8="; asn = 4242421513; e6 = "fe80::1513"; }
    { name = "wg1817"; listen = 21817; publickey = "Sxn9qXnzu3gSBQFZ0vCh5t5blUJYgD+iHlCCG2hexg4="; asn = 4242421817; e6 = "fe80::42:1817:a"; }
    { name = "wg2189"; listen = 22189; endpoint = "de-fra.dn42.kuu.moe:57353"; publickey = "FHp0OR4UpAS8/Ra0FUNffTk18soUYCa6NcvZdOgxY0k="; asn = 4242422189; e6 = "fe80::2189:e9"; }
    { name = "wg2331"; listen = 22331; endpoint = "lu208.dn42.williamgates.info:21888"; publickey = "c4AZZVNUzXCASWG96CKUpY+gQLdGwA1rbqkYCHXnW10="; asn = 4242422331; e6 = "fe80::2331"; }
    { name = "wg2458"; listen = 22458; endpoint = "nl-ams-a.nodes.pigeonhole.eu.org:51888"; publickey = "QJnmWUnPS9wKKkLHHuWBYMGAI20MH9OEo28O4qr5DV8="; asn = 4242422458; e6 = "fe80::2458"; }
    { name = "wg2717"; listen = 22717; endpoint = "nl.vm.whojk.com:23024"; publickey = "cokP4jFBH0TlBD/m3sWCpc9nADLOhzM2+lcjAb3ynFc="; asn = 4242422717; e6 = "fe80::2717"; }
    { name = "wg2837"; listen = 22837; endpoint = "lux1.eki.moe:21888"; publickey = "rvzaIe2JwsZk3pgA59Xf0SNS1gB0GSgegvOoYcDVgGc="; asn = 4242422837; e6 = "fe80::2837"; }
    { name = "wg2923"; listen = 22923; endpoint = "p2p-node.de:51888"; publickey = "GD554w8JM8R2s0c/mR7sBbYy/zTP5GWWB+Zl1gx5GUk="; asn = 4242422923; e6 = "fe80::2923"; }
    { name = "wg2980"; listen = 22980; endpoint = "fra1.de.dn42.yuuta.moe:21888"; publickey = "GYEhSHmPD0pVX3xBKa7SAwnuCyMA2oOsaHBgFpPO4X4="; presharedkey = "iHxtuu7sFtvR/nsOA2m3T4Lt3w8P4VzvLKHWAm23a1w="; asn = 4242422980; e6 = "fe80::2980"; }
    { name = "wg3044"; listen = 23044; endpoint = "nl.dn42.ssssteve.one:21888"; publickey = "ighiBJss6sW+CZpMAzks13WVDud3VWrouPBHWJu9kDg="; asn = 4242423044; e6 = "fe80::3044"; }
    { name = "wg3396"; listen = 23396; endpoint = "uk1.dn42.theresa.cafe:21888"; publickey = "zhDkw8DNmH5spOWh12790/zPA9NKblr2taIDPM5G/g4="; asn = 4242423396; e6 = "fe80::3396"; }
    { name = "wg3847"; listen = 23847; endpoint = "de-flk-dn42.0011.de:21888"; publickey = "b8jJ2n2CyAm3iGvVl95Rc9yINXqHd16y4OkW40zV0FQ="; asn = 4242423847; e6 = "fe80::42:3847:42:1888"; }
    { name = "wg3868"; listen = 23868; endpoint = "fra1.dn42.cooo.cool:21888"; publickey = "UFDPre74vbNAV+e2dvdeEWNqT4h8X8ryyIrNIGWWUzU="; asn = 4242423868; e6 = "fe80::3868"; }
  ];
}
