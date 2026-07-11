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
    ];
  };
}
