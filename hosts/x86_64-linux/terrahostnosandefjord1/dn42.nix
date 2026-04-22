{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
      {
        name = "wg0129";
        listen = 20129;
        endpoint = "no1.420129.xyz:21888";
        publickey = "m724+dPvbZAoOI680+Add37Qdy8wuV1MfyFkHKTWaUM=";
        presharedkey = "bMj7QnOxYsVglAYt6eE0nfd7yZxbizeKwUO7Ffp6ftk=";
        asn = 4242420129;
        e6 = "fe80::129:a";
      }
    ];
  };
}
