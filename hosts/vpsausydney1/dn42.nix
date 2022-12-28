{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg0458"; listen = 20458; endpoint = "au-east1.nodes.huajinet.org:21888"; publickey = "LeNGkX12n1Dcq8eNE1HhvpnFxrPlzgWlNncFlHdi5DY="; asn = 4242420458; e6 = "fe80::0458"; }
    { name = "wg1080"; listen = 21080; endpoint = "syd.peer.highdef.network:21888"; publickey = "Xk9wCuwp3zK4WflTeAKBIjgIlr3+qUwIFCkF2uMyyF8="; asn = 4242421080; e6 = "fe80::1080:125"; }
    { name = "wg2633"; listen = 22633; endpoint = "syd.eastbnd.com:21888"; publickey = "LCiWfrhsgJ28FDu0m/xxCwrxIiiqQNh7Df9j2393JkQ="; asn = 4242422633; e6 = "fe80::2633"; }
  ];
}