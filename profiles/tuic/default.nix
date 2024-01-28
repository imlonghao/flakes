{ config, self, sops }:
{
  sops.secrets.tuic-uuid.sopsFile = "${self}/secrets/tuic.yml";
  sops.secrets.tuic-password.sopsFile = "${self}/secrets/tuic.yml";
  sops.secrets.tuic-sni.sopsFile = "${self}/secrets/tuic.yml";
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "tuic";
          listen = "::";
          listen_port = 443;
          users = [
            {
              uuid = {
                _secret = config.sops.secrets.tuic-uuid.path;
              };
              password = {
                _secret = config.sops.secrets.tuic-password.path;
              };
            }
          ];
          congestion_control = "bbr";
          tls = {
            enabled = true;
            server_name = {
              _secret = config.sops.secrets.tuic-sni.path;
            };
            certificate_path = "/persist/pki/.lego/certificates/esd.cc.crt";
            key_path = "/persist/pki/.lego/certificates/esd.cc.key";
          };
        }
      ];
      outbounds = [
        {
          type = "direct";
        }
      ];
    };
  };
}
