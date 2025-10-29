{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = {
    enable = true;
    peers = [
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
        name = "wg0566";
        listen = 20566;
        endpoint = "dn22.syd.surgebytes.com:31888";
        publickey = "m8HdhB90mg8NcBgWGeplQBpc5BgPLVk80OZWZyOXqVk=";
        asn = 4242420566;
        e6 = "fe80::566:22";
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
        name = "wg1855";
        listen = 21855;
        endpoint = "[2402:1f00:8100:400::2274]:41105";
        publickey = "zVWKR85D+zFtSsQVFDKL2rz3tUvxlKHB5HTXaYSfXwI=";
        presharedkey = "04WpcjW20Z9SHwC6JhxjwGQ6D4337NDNETnKYQbtJ2g=";
        asn = 4242421855;
        e6 = "fe80::1855";
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
        name = "wg3290";
        listen = 23290;
        endpoint = "119.224.65.18:21888";
        publickey = "P2Kjb9ddKc04VZszk3Y/TCRTHtwiyYVOAxAX7CH7eTs=";
        presharedkey = "qiS3TbealSY3WhRZmF90XFRJqtYhF17kN+7Sa3qRQUM=";
        asn = 4242423290;
        e6 = "fe80::3290";
      }
      {
        name = "wg3797";
        listen = 23797;
        asn = 4242423797;
        e6 = "fe80::3797";
        endpoint = "au-syd1.rc.badaimweeb.me:50052";
        publickey = "tS7iDDIWQJQoHCc60Jz7I2grikAAAFhNApC3jEeUcxk=";
      }
    ];
  };
}
