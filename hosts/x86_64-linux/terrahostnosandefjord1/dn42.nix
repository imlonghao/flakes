{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg0123";
        listen = 20123;
        endpoint = "gw-osl-no.dn42.grmml.net:51888";
        publickey = "2R1KLm5HJGXhUQkUlA1XsiynkBhZqRaTV8G2xrldag8=";
        asn = 4242420123;
        local_role = "peer";
        e6 = "fe80::149:c";
      }
      {
        name = "wg0129";
        listen = 20129;
        endpoint = "no1.420129.xyz:21888";
        publickey = "m724+dPvbZAoOI680+Add37Qdy8wuV1MfyFkHKTWaUM=";
        presharedkey = "bMj7QnOxYsVglAYt6eE0nfd7yZxbizeKwUO7Ffp6ftk=";
        asn = 4242420129;
        local_role = "peer";
        e6 = "fe80::129:a";
      }
      {
        name = "wg3155";
        listen = 23155;
        endpoint = "r.home.skym.fi:52673";
        publickey = "X2XTlhMRTkIQRU6P4r6OeOM3JHXvxTcHqCHM+40dKEw=";
        asn = 4242423155;
        e6 = "fe80::5f65:d396:1311:4e42";
      }
    ];
  };
}
