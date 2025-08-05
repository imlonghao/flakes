{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [ ];
  };
}
