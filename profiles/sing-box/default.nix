{ config, self, sops, ... }: {
  sops.secrets.sing-box-uuid.sopsFile = "${self}/secrets/sing-box.yml";
  sops.secrets.sing-box-password.sopsFile = "${self}/secrets/sing-box.yml";
  sops.secrets.sing-box-sni.sopsFile = "${self}/secrets/sing-box.yml";
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "shadowtls";
          listen = "::";
          listen_port = 4443;
          version = 3;
          users = [{
            name = "toor";
            password = {
              _secret = config.sops.secrets.sing-box-password.path;
            };
          }];
          handshake = {
            server = "i0.hdslb.com";
            server_port = 443;
          };
          detour = "s5-in";
          tcp_multi_path = true;
        }
        {
          type = "socks";
          tag = "s5-in";
          listen = "127.0.0.1";
        }
        {
          type = "sing-box";
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
