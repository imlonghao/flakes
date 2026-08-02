{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg0207";
        listen = 20207;
        endpoint = "router.ewr1.routedbits.com:51888";
        publickey = "Yelo0BWe4ggUQ1jTKmC1Tq2Tqg1jyKiVU5xz+qY0yU0=";
        asn = 4242420207;
        e6 = "fe80::0207";
      }
      {
        name = "wg3432";
        asn = 4242423432;
        e6 = "fe80::3432";
        listen = 23432;
        endpoint = "chi1.dn42.s6v.net:42028";
        publickey = "P/I3fB5v79G4holxGCpoz5Iuu04r1lAX5CeqJacc0QM=";
      }
    ];
  };
}
