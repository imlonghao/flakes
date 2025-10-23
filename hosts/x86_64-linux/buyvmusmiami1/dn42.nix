{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
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
        name = "wg0150";
        e6 = "fe80::150";
        asn = 4242420150;
        listen = 20150;
        endpoint = "iad.darkpoint.xyz:21888";
        publickey = "1o0XfQvBM1gqknqzfuOnVmf2RjRTHuyMZYNipSSb2TQ=";
      }
      {
        name = "wg0202";
        e6 = "fe80::202:13";
        asn = 4242420202;
        listen = 20202;
        endpoint = "dn13.fl.us.sdubs.vip:21888";
        publickey = "EmfS2i5so0cRHbMc/sY4pfojcHnQNnXaqlXZk0wS+xc=";
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
        name = "wg1240";
        listen = 21240;
        endpoint = "us-04.prefixlabs.net:21888";
        publickey = "go4mNE2VCuM/85Cy9tNlZN90qi+5RYGWfmoymAjEF3g=";
        asn = 4242421240;
        e6 = "fe80::1240:8";
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
        name = "wg2002";
        e6 = "fe80::2002:1";
        asn = 4242422002;
        listen = 22002;
        publickey = "CHXW5JLVxc7hksJ9eUFc/OCUoET3qPu1PcOCOhR2bTw=";
      }
      {
        name = "wg2092";
        listen = 22092;
        endpoint = "us0.dn42.pebkac.gr:51888";
        publickey = "NnIsCmxiGctp5hR9ViuNRjZXr8lxtjn382sIwsV+GBU=";
        asn = 4242422092;
        e6 = "fe80::ffff:2092";
      }
      {
        name = "wg2189";
        asn = 4242422189;
        e6 = "fe80::2189:124";
        listen = 22189;
        endpoint = "us-nyc.dn42.iedon.net:46152";
        publickey = "2Wmv10a9eVSni9nfZ7YPsyl3ZC5z7vHq0sTZGgk5WGo=";
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
        name = "wg2601";
        asn = 4242422601;
        e6 = "fe80::42:2601:37:1";
        listen = 22601;
        endpoint = "dn42-us-ash1.burble.com:21888";
        publickey = "rTOD+9hPk4TQ5YDPXzTMsp7msHpvW3hOMo5r/PRlzAU=";
      }
      {
        name = "wg3914";
        e6 = "fe80::ade0";
        asn = 4242423914;
        endpoint = "us2.g-load.eu:21888";
        publickey = "6Cylr9h1xFduAO+5nyXhFI1XJ0+Sw9jCpCDvcqErF1s=";
      }
      {
        name = "wg3997";
        asn = 4242423997;
        e6 = "fe80::3997";
        listen = 23997;
        endpoint = "us1.dn42.bitrate.studio:21888";
        publickey = "fVPguFQdWzddNaroGp8AfsgEqrAUywgNq5nu6iV1mzE=";
      }
    ];
  };
}
