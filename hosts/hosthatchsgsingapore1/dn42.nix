{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    { name = "wg31111"; listen = 31111; publickey = "7TIbiifNzh8HxLUM8cBvwmBo/kuaCAUCRahbBMoVA1Q="; asn = 4201271111; e6 = "fe80::aa:1111:11"; }
    { name = "wg0207"; listen = 20207; endpoint = "router.sin1.routedbits.com:51888"; publickey = "8sTnWN7ykPaDe1WIZOlnqECiGMJzwXB8TXWHcT7qnEw="; asn = 4242420207; e6 = "fe80::0207"; }
    { name = "wg0458"; listen = 20458; endpoint = "sg1.nodes.huajinet.org:21888"; publickey = "uVQSqDCJZzbMND7rRmoOR3QpANgl2SbTlv28aw0kh3w="; asn = 4242420458; e6 = "fe80::0458"; }
    { name = "wg0585"; listen = 20585; endpoint = "sg1.dn42.atolm.net:21888"; publickey = "nI/itxRxKHntsWiBpawMZe2vOFho1rrOJdK7th0ZxFg="; asn = 4242420585; e6 = "fe80::585"; }
    { name = "wg0604"; listen = 20604; endpoint = "sgp1.dn42.cas7.moe:21888"; publickey = "R8iyaSzF6xx/t4+1wKlYWZWyZOxJDCXlA2BE3OZnsAY="; asn = 4242420604; e6 = "fe80::0604"; }
    { name = "wg0831"; listen = 20831; endpoint = "sg.dn42.tms.im:21888"; publickey = "KlZg3oOjQsaQ0dNkUgHCKyOqULw8+u+llo97X1w5mV4="; asn = 4242420831; e6 = "fe80::0831"; }
    { name = "wg1080"; listen = 21080; endpoint = "sgp.peer.highdef.network:21888"; publickey = "X3m9VMzZYN4Oe2QUb7DcnmVymwKSLbPUCB5ElD8igjo="; asn = 4242421080; e6 = "fe80::1080:39"; }
    { name = "wg1588"; listen = 21588; endpoint = "sg-sin01.dn42.tech9.io:59771"; publickey = "4qLIJ9zpc/Xgvy+uo90rGso75cSrT2F5tBEv+6aqDkY="; asn = 4242421588; ipv6 = "fe80::100/64"; e4 = "172.20.16.142"; e6 = "fe80::1588"; l4 = "172.22.68.2"; }
    { name = "wg2225"; listen = 22225; endpoint = "dn42-sg.maraun.de:21888"; publickey = "rWTIK93+XJaP4sRvrk1gqXxAZgkz6y/axLC4mjuay1I="; asn = 4242422225; e6 = "fe80::2225"; }
    { name = "wg2237"; listen = 22237; endpoint = "sg-sin01.dn42.munsternet.eu:21888"; publickey = "09m8ilgZ/9jQvVgsGwu2ceR8u6gKAsd+VxH8AzduOHk="; asn = 4242422237; e6 = "fe80::42:2237"; }
    { name = "wg2246"; listen = 22246; endpoint = "sin05.dn42.ventilaar.net:31888"; publickey = "+VyvdteLe/IRArhjFhqszJdKVDMkJWrbbINEaL7WGyc="; asn = 4242422246; e6 = "fe80::2246"; }
    { name = "wg2271"; listen = 22271; endpoint = "185.212.61.190:21888"; publickey = "9RBImDH9X0NghJsVW6hAVQS1qaR+RXrsbVXisBAViHE="; asn = 4242422271; e6 = "fe80::2271"; }
    { name = "wg2297"; listen = 22297; endpoint = "[2001:448a:2020:906b::1]:21888"; publickey = "dwsCsA9BHq1u0f17OYNjOd5wP7X402PSVXjm3PeM8yE="; asn = 4242422297; e6 = "fe80::770b:2b0:f41:1ead"; e4 = "172.23.9.128"; l4 = "172.22.68.0"; mpbgp = false; }
    { name = "wg2503"; listen = 22503; endpoint = "sg.dn42.sam1314.com:21888"; publickey = "64JddgLTLWrbxZu8/b/d7Nq8vPZJrKK9+1fMJbX78HE="; asn = 4242422503; e4 = "172.23.161.64"; e6 = "fe80::2503"; l4 = "172.22.68.0"; mpbgp = false; }
    { name = "wg2633"; listen = 22633; endpoint = "sin.eastbnd.com:21888"; publickey = "m5IfciUmvMEfDkfFQf0jD3GH0F0ChMktOSiLMlJ29wc="; asn = 4242422633; e4 = "172.23.250.34"; e6 = "fe80::2633"; l4 = "172.22.68.2"; }
    { name = "wg2717"; listen = 22717; endpoint = "sg.vm.whojk.com:24103"; publickey = "vCtn1DbfIiTgcMapuEGB/+/HnLeEPKPjxJbt/sjviTs="; asn = 4242422717; e6 = "fe80::2717"; }
  ];
}
