{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg64719";
      l4 = "172.22.68.1";
      e4 = "172.22.119.10";
      e6 = "fe80::acab";
      asn = 64719;
      listen = 64719;
      endpoint = "us-nyc.dn42.lutoma.org:42591";
      publickey = "ClSMc4CO3PARJ4gRgcee4DDTAxa8tEeDxFDtBDb0bCk=";
    }
    {
      name = "wg0207";
      listen = 20207;
      endpoint = "router.mia1.routedbits.com:51888";
      publickey = "7v+CFwv6ptPDWWBtLoSJBq8+jC+jTD8QbRtt6NCYegw=";
      asn = 4242420207;
      e6 = "fe80::0207";
    }
    {
      name = "wg0247";
      l4 = "172.22.68.1";
      e4 = "172.23.250.81";
      e6 = "fe80::247";
      asn = 4242420247;
      listen = 20247;
      endpoint = "us1.dn42.as141776.net:41888";
      publickey = "tRRiOqYhTsygV08ltrWtMkfJxCps1+HUyN4tb1J7Yn4=";
    }
    {
      name = "wg0358";
      e6 = "fe80::358";
      asn = 4242420358;
      listen = 20358;
      endpoint = "nj.us.dn42.kemonos.net:21888";
      publickey = "hfurIssgtoOzzZM01AVfCM9vo+MxNCCLf15k7NbVxHM=";
    }
    {
      name = "wg0566";
      e6 = "fe80::566:9";
      asn = 4242420566;
      listen = 20566;
      endpoint = "dn09.fl.surgebytes.com:31888";
      publickey = "L1nrGl7ggHnyKejJ5eYAPmtVnTZK03ObhpG71FXNXxM=";
    }
    {
      name = "wg1080";
      e6 = "fe80::1080:119";
      asn = 4242421080;
      listen = 21080;
      endpoint = "atl.peer.highdef.network:21888";
      publickey = "gbhhdvAIHVuv5e+tIG/m9T9fDaGoAGVgSUHq+rKTLyY=";
    }
    {
      name = "wg1411";
      e6 = "fe80::1411:2";
      asn = 4242421411;
      listen = 21411;
      endpoint = "karx.xyz:21888";
      publickey = "Ta5Dq6wr5OcY3m369cpnUbTzjFM2MSR631VRLM1Syyk=";
    }
    {
      name = "wg2464";
      e6 = "fe80::2464";
      asn = 4242422464;
      listen = 22464;
      endpoint = "nyc.dneo.moeternet.com:21888";
      publickey = "MLVJrwrph6d0VqrAq8/rkhbkG+mrQNytqmwrNgk2qFs=";
    }
    {
      name = "wg2547";
      l4 = "172.22.68.1";
      e4 = "172.22.76.190";
      e6 = "fe80::2547";
      asn = 4242422547;
      listen = 22547;
      endpoint = "virmach-ny1g.lantian.pub:21888";
      publickey = "a+zL2tDWjwxBXd2bho2OjR/BEmRe2tJF9DHFmZIE+Rk=";
    }
    {
      name = "wg2825";
      e6 = "fe80::1588:e";
      asn = 4242422825;
      listen = 22825;
      endpoint = "evo.pve.ibeep.com:21888";
      publickey = "CudK5JJnGdSOAcpnerxfbp7nGb+fGUknL5SDTdTwkxI=";
    }
    {
      name = "wg3914";
      l4 = "172.22.68.1";
      e4 = "172.20.53.98";
      e6 = "fe80::ade0";
      asn = 4242423914;
      endpoint = "us2.g-load.eu:21888";
      publickey = "6Cylr9h1xFduAO+5nyXhFI1XJ0+Sw9jCpCDvcqErF1s=";
    }
  ];
}
