{ config, self, sops, ... }: {
  sops.secrets.tuic-uuid.sopsFile = "${self}/secrets/tuic.yml";
  sops.secrets.tuic-password.sopsFile = "${self}/secrets/tuic.yml";
  sops.secrets.tuic-sni.sopsFile = "${self}/secrets/tuic.yml";
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
            password = { _secret = config.sops.secrets.tuic-password.path; };
          }];
          handshake = {
            server = "i0.hdslb.com";
            server_port = 443;
          };
          detour = "s5-in";
          tcp_fast_open = true;
          tcp_multi_path = true;
        }
        {
          type = "socks";
          tag = "s5-in";
          listen = "127.0.0.1";
        }
        {
          type = "tuic";
          listen = "::";
          listen_port = 443;
          users = [{
            uuid = { _secret = config.sops.secrets.tuic-uuid.path; };
            password = { _secret = config.sops.secrets.tuic-password.path; };
          }];
          congestion_control = "bbr";
          tls = {
            enabled = true;
            server_name = { _secret = config.sops.secrets.tuic-sni.path; };
            certificate_path = "/persist/pki/.lego/certificates/esd.cc.crt";
            key_path = "/persist/pki/.lego/certificates/esd.cc.key";
          };
        }
      ];
      outbounds = [{ type = "direct"; }];
    };
  };
}
