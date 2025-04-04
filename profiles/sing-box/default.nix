{ config, self, ... }: {
  sops.secrets.sing-box-uuid.sopsFile = "${self}/secrets/sing-box.yml";
  sops.secrets.sing-box-password.sopsFile = "${self}/secrets/sing-box.yml";
  sops.secrets.sing-box-sni.sopsFile = "${self}/secrets/sing-box.yml";
  sops.secrets.sing-box-encrypt.sopsFile = "${self}/secrets/sing-box.yml";
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "shadowsocks";
          listen = "::";
          listen_port = 4443;
          tcp_multi_path = true;
          method = "2022-blake3-aes-256-gcm";
          password = { _secret = config.sops.secrets.sing-box-encrypt.path; };
          multiplex = {
            enabled = true;
            padding = true;
          };
        }
        {
          type = "tuic";
          listen = "::";
          listen_port = 443;
          users = [{
            uuid = { _secret = config.sops.secrets.sing-box-uuid.path; };
            password = {
              _secret = config.sops.secrets.sing-box-password.path;
            };
          }];
          congestion_control = "bbr";
          tls = {
            enabled = true;
            server_name = { _secret = config.sops.secrets.sing-box-sni.path; };
            certificate_path = "/persist/pki/.lego/certificates/esd.cc.crt";
            key_path = "/persist/pki/.lego/certificates/esd.cc.key";
          };
        }
      ];
      outbounds = [{ type = "direct"; }];
    };
  };
}
