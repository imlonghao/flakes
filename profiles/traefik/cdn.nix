{ ... }: {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = { address = ":80"; };
        websecure = {
          address = ":443";
          http3 = { };
        };
      };
      providers = { etcd.endpoints = [ "100.64.88.23:2379" ]; };
    };
    dynamicConfigOptions = {
      tls = {
        certificates = [
          {
            certFile = "/persist/pki/.lego/certificates/esd.cc.crt";
            keyFile = "/persist/pki/.lego/certificates/esd.cc.key";
          }
          {
            certFile = "/persist/pki/.lego/certificates/mtr.sb.crt";
            keyFile = "/persist/pki/.lego/certificates/mtr.sb.key";
          }
        ];
      };
    };
  };
}
