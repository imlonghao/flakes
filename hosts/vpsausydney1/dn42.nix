{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg0002";
      listen = 20002;
      endpoint = "syd1.dn42.michaeldale.com.au:21888";
      publickey = "Jcm1aWOwNR806xj6bjiyrfyTp6Sto8etYBsdQ2OnAGQ=";
      asn = 4242420002;
      e6 = "fe80::e7db";
    }
    {
      name = "wg0207";
      listen = 20207;
      endpoint = "router.syd1.routedbits.com:51888";
      publickey = "wgCrE2lSvrfctVSngdHo6iAT/RRK7gNldJcFIFKi/Go=";
      asn = 4242420207;
      e6 = "fe80::0207";
    }
    {
      name = "wg0458";
      listen = 20458;
      endpoint = "au-east1.nodes.huajinet.org:21888";
      publickey = "LeNGkX12n1Dcq8eNE1HhvpnFxrPlzgWlNncFlHdi5DY=";
      asn = 4242420458;
      e6 = "fe80::0458";
    }
    {
      name = "wg0459";
      listen = 20459;
      endpoint = "au1.fakemsp.cloud:21888";
      publickey = "L/6MJt5U0sMMV6YqfQUdb1AUKg4G8Tvza3nEPMiR53s=";
      asn = 4242420459;
      e6 = "fe80::8523:45ff:fe20:8b5";
    }
    {
      name = "wg1080";
      listen = 21080;
      endpoint = "syd.peer.highdef.network:21888";
      publickey = "Xk9wCuwp3zK4WflTeAKBIjgIlr3+qUwIFCkF2uMyyF8=";
      asn = 4242421080;
      e6 = "fe80::1080:125";
    }
    {
      name = "wg1815";
      listen = 21815;
      endpoint = "server1.rivensbane.com:21888";
      publickey = "SzxSzCLbWGpzPeYtnSXHJCVJmrjjCcJR1L13KVFTKW8=";
      asn = 4242421815;
      e6 = "fe80::5614";
    }
    {
      name = "wg2633";
      listen = 22633;
      endpoint = "syd.eastbnd.com:21888";
      publickey = "LCiWfrhsgJ28FDu0m/xxCwrxIiiqQNh7Df9j2393JkQ=";
      asn = 4242422633;
      e6 = "fe80::2633";
    }
    {
      name = "wg3035";
      listen = 23035;
      endpoint = "nz01.dn42.lare.cc:21888";
      publickey = "OhpIfAMN/YsQrl/gMPDr8OwFkVXvREpmrfjPv3U5/Fg=";
      asn = 4242423035;
      e6 = "fe80::3035:134";
      e4 = "172.22.125.134";
      l4 = "172.22.68.9";
    }
  ];
}
