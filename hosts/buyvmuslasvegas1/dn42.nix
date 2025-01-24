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
    {
      name = "wg0207";
      listen = 20207;
      endpoint = "router.lax1.routedbits.com:51888";
      publickey = "s4uGYMeLV30vO/Z3+c1qrg/YA1eIMRVFYUsZEGD1hH8=";
      asn = 4242420207;
      e6 = "fe80::0207";
    }
    {
      name = "wg0358";
      e6 = "fe80::358";
      asn = 4242420358;
      listen = 20358;
      endpoint = "sjc.us.dn42.kemonos.net:21888";
      publickey = "7HzHyeA2M7yo/zVmc+e0zG+I7j2SnIx+7ZpXOca93mg=";
    }
    {
      name = "wg0398";
      listen = 20398;
      endpoint = "lax.dn42.boletus.me:21888";
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
    {
      name = "wg0585";
      listen = 20585;
      endpoint = "us1.dn42.atolm.net:21888";
      publickey = "mhnMFoFExt6OFbSe83Er2MCuFldlZfCb5LP9tBkVfEE=";
      asn = 4242420585;
      e6 = "fe80::585";
    }
    {
      name = "wg0625";
      listen = 20625;
      endpoint = "arcenotas.com:21888";
      publickey = "8l+9N8cEygZTv/yhqb4giA230o2/DGn2P6wytYVHrHw=";
      asn = 4242420625;
      e6 = "fe80::0625";
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
    {
      name = "wg1716";
      e6 = "fe80::1716:1888";
      asn = 4242421716;
      listen = 21716;
      endpoint = "1888.dn42.nngnn.com:21888";
      publickey = "9wjlepdAM+yr/G3VoI2bc6ogDUiPcE4UsUzadJn0jnA=";
    }
    {
      name = "wg1771";
      listen = 21771;
      asn = 4242421771;
      e6 = "fe80::afaf:bfbf:cdcf:2d";
      endpoint = "148.135.56.215:32596";
      publickey = "6oeRQx3cKLqZw/ncMNVIErZKz1sTaYKhqt5E9WoiRFQ=";
    }
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
      name = "wg2002";
      e6 = "fe80::2002:4";
      asn = 4242422002;
      listen = 22002;
      publickey = "oYVbaUTF3+6hiaQQsUqvwdzUD+USsXnwdaDDgxuGF0E=";
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
      name = "wg3035";
      listen = 23035;
      endpoint = "usw1.dn42.lare.cc:21888";
      publickey = "Qd2XCotubH4QrQIdTZjYG4tFs57DqN7jawO9vGz+XWM=";
      asn = 4242423035;
      e6 = "fe80::3035:132";
    }
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
