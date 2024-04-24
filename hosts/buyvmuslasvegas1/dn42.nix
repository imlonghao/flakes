{ ... }:

{
  sops.secrets.wireguard.sopsFile = ./secrets.yml;
  dn42 = [
    {
      name = "wg64719";
      e4 = "172.22.119.11";
      e6 = "fe80::acab";
      l4 = "172.22.68.5";
      listen = 64719;
      asn = 64719;
      endpoint = "us-lax.dn42.lutoma.org:42560";
      publickey = "uspTFQKijQUTbxUgh2IzbNaCUZgtdgrn0kUtbPDd5gM=";
    }
    { name = "wg0207"; listen = 20207; endpoint = "router.lax1.routedbits.com:51888"; publickey = "s4uGYMeLV30vO/Z3+c1qrg/YA1eIMRVFYUsZEGD1hH8="; asn = 4242420207; e6 = "fe80::0207"; }
    {
      name = "wg0253";
      asn = 4242420253;
      e6 = "fe80::0253";
      listen = 20253;
      endpoint = "sfo1.dn42.moe233.net:21888";
      publickey = "C3SneO68SmagisYQ3wi5tYI2R9g5xedKkB56Y7rtPUo=";
    }
    {
      name = "wg0377";
      listen = 20377;
      endpoint = "us-lax1.zycname.eu.org:21888";
      publickey = "qWFgfcWROVCagHgrA5qy6oEsxziSb4EbzmtWp4F5yjc=";
      asn = 4242420377;
      e6 = "fe80::0377";
    }
    {
      name = "wg0398";
      listen = 20398;
      endpoint = "lax.dn42.akihi.me:21888";
      publickey = "oAPy0U2qVuSR8PyPLmVLEgWLBKrOq4kcLNLAOVZL10M=";
      asn = 4242420398;
      e6 = "fe80::426f";
    }
    {
      name = "wg0458";
      listen = 20458;
      asn = 4242420458;
      e6 = "fe80::0458";
      endpoint = "us-west1.nodes.huajinet.org:21888";
      publickey = "Y13v0Xzf6zJQGtL2qJSwVyLNSxipYoGpq4y/5aU7omg=";
    }
    { name = "wg0585"; listen = 20585; endpoint = "us1.dn42.atolm.net:21888"; publickey = "mhnMFoFExt6OFbSe83Er2MCuFldlZfCb5LP9tBkVfEE="; asn = 4242420585; e6 = "fe80::585"; }
    {
      name = "wg0826";
      e4 = "172.23.196.0";
      l4 = "172.22.68.5";
      listen = 20826;
      asn = 4242420826;
      e6 = "fe80::a0e:fb02";
      endpoint = "v4.la.dn42.dgy.xyz:21888";
      publickey = "IXjFALJFTr24HAhXKDsCnTRXmlc3kJHJiR4Nr44l5Uw=";
    }
    {
      name = "wg0864";
      listen = 20864;
      asn = 4242420864;
      e6 = "fe80::864:2";
      endpoint = "lax.dn42.christine.pp.ua:21888";
      publickey = "mOQs7kIucUmSDXqRHvwfUxLAFkUDg9ssH5Gqn+6oj0s=";
    }
    {
      name = "wg1080";
      listen = 21080;
      asn = 4242421080;
      e6 = "fe80::1080:126";
      endpoint = "las.peer.highdef.network:42424";
      publickey = "oHxFupY7yiSRmRpWB2mfXzfXam5fGyxQ313TWszk0Es=";
    }
    {
      name = "wg1123";
      listen = 21123;
      asn = 4242421123;
      e6 = "fe80::1123";
      endpoint = "lax.ccp.ovh:21888";
      publickey = "Z6OKJSR1sxMBgUd1uXEe/UxoBsOvRgbTnexy7z/ryUI=";
    }
    { name = "wg1350"; listen = 21350; endpoint = "sea.jvav.tech:21888"; publickey = "VCYdDHIKBDfHe+drn2CG6pw56HBzDeoRt6wAx6GUg0Y="; asn = 4242421350; e6 = "fe80::1350"; }
    { name = "wg1580"; listen = 21580; endpoint = "sfo.dn42.noreinx.me:21888"; publickey = "uUKad5JFD+Zfx/sApOcqJVrrsRS25en9ac6Tri/cZQk="; asn = 4242421580; e6 = "fe80::1580:1"; }
    { name = "wg1816"; listen = 21816; endpoint = "us1.dn42.potat0.cc:21888"; publickey = "LUwqKS6QrCPv510Pwt1eAIiHACYDsbMjrkrbGTJfviU="; asn = 4242421816; e6 = "fe80::1816"; }
    {
      name = "wg1817";
      listen = 21817;
      asn = 4242421817;
      e6 = "fe80::1817";
      endpoint = "4.us.kskb.eu.org:21888";
      publickey = "dZzVdXbQPnWPpHk8QfW/p+MfGzAkMBuWpxEIXzQCggY=";
    }
    {
      name = "wg1877";
      listen = 21877;
      asn = 4242421877;
      e6 = "fe80::1d90";
      endpoint = "suzuran.lilynet.work:21888";
      publickey = "E/+f5HM2EEw7CV574nYj+51bRNJDOZ6C5BKSQBpMGgw=";
    }
    {
      name = "wg2032";
      listen = 22032;
      asn = 4242422032;
      e6 = "fe80::2032";
      endpoint = "las1.us.lapinet27.com:21888";
      publickey = "KlvNQ7wBwoey0N8YpJYsYuHDrxjpIzHqCh9osAzcEyA=";
    }
    {
      name = "wg2189";
      listen = 22189;
      asn = 4242422189;
      e6 = "fe80::2189:ef";
      endpoint = "us-lax.dn42.kuu.moe:42216";
      publickey = "DIw4TKAQelurK10Sh1qE6IiDKTqL1yciI5ItwBgcHFA=";
    }
    {
      name = "wg2458";
      listen = 22458;
      asn = 4242422458;
      e6 = "fe80::2458";
      endpoint = "us-sjc-a.nodes.pigeonhole.eu.org:51888";
      publickey = "usSOnTQKWozKiB3CM65TY3hv64dxQLnIx9ywc0J9awY=";
    }
    {
      name = "wg2464";
      listen = 22464;
      asn = 4242422464;
      e6 = "fe80::2464";
      endpoint = "las.dneo.moeternet.com:21888";
      publickey = "viR4CoaJTBHROo/Bgbb27hQ2ttr8AbByGY/yOz3D3GY=";
    }
    {
      name = "wg2688";
      listen = 22688;
      asn = 4242422688;
      e6 = "fe80::2688";
      endpoint = "lv1-v4.us.dn42.miaotony.xyz:21888";
      publickey = "vfrrbtKAO5438daHrTD0SSS8V6yk78S/XW7DeFrYLXA=";
    }
    {
      name = "wg2705";
      listen = 22705;
      asn = 4242422705;
      e6 = "fe80::4242:2705";
      endpoint = "sea1.node.piggy.moe:21888";
      publickey = "bs3UoHA1NcJzfXdBubSrHbfcwfAW1tTHTlhUyoQa9lU=";
    }
    {
      name = "wg2980";
      ipv4 = "172.22.68.5";
      ipv6 = "fe80::1888:5/64";
      e4 = "172.23.105.3";
      l4 = "172.22.68.5";
      listen = 22980;
      asn = 4242422980;
      e6 = "fe80::2980";
      endpoint = "sjc1.us.dn42.yuuta.moe:21888";
      publickey = "2ev+fMK6mIP/v0S9Sq7MlqLhNn0La1VpYiPomgPTD2g=";
      presharedkey = "eDDRji2SoboBoAjQJUCZdsXN9iJJdaxy679BR6F0ukI=";
    }
    {
      name = "wg3021";
      e4 = "172.23.33.161";
      l4 = "172.22.68.5";
      listen = 23021;
      asn = 4242423021;
      e6 = "fe80::947e";
      endpoint = "us1.dn42.ciplc.network:21888";
      publickey = "qgTT/xzJWZH9iAN+8JW7nWgzk2/i1elposz7G7bnczY=";
    }
    { name = "wg3035"; listen = 23035; endpoint = "usw1.dn42.lare.cc:21888"; publickey = "Qd2XCotubH4QrQIdTZjYG4tFs57DqN7jawO9vGz+XWM="; asn = 4242423035; e6 = "fe80::3035:132"; }
    {
      name = "wg3088";
      listen = 23088;
      asn = 4242423088;
      e6 = "fe80::3088:193";
      endpoint = "lax1-us.dn42.6700.cc:30012";
      publickey = "QSAeFPotqFpF6fFe3CMrMjrpS5AL54AxWY2w1+Ot2Bo=";
    }
  ];
}
