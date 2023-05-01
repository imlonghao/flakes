{ age, config, pkgs, self, sops, ... }:

{
  environment.etc."mtr.sb/worker.hcl".text = ''
    cert_path = "/persist/mtr.sb/${config.networking.hostName}.crt"
    key_path = "/persist/mtr.sb/${config.networking.hostName}.pem"
    server_ca_path = "/persist/mtr.sb/imlonghao_Network_Tools_Server_CA.crt"
  '';
  services.mtrsb = {
    enable = true;
  };
}
