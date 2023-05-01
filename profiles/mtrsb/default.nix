{ age, config, pkgs, self, sops, ... }:
let
  ca = pkgs.writeText "ca.crt" ''
    -----BEGIN CERTIFICATE-----
    MIICHTCCAaKgAwIBAgIIW0RzOWV1FYQwCgYIKoZIzj0EAwIwMDESMBAGA1UEChMJ
    aW1sb25naGFvMRowGAYDVQQDExFpbWxvbmdoYW8gUm9vdCBDQTAeFw0yMzA0Mjgw
    MDAwMDBaFw0zMzA0MjcyMzU5NTlaMEAxEjAQBgNVBAoTCWltbG9uZ2hhbzEqMCgG
    A1UEAxMhaW1sb25naGFvIE5ldHdvcmsgVG9vbHMgU2VydmVyIENBMHYwEAYHKoZI
    zj0CAQYFK4EEACIDYgAEC2uWPf8KHQ/meK2nVihF0WkSERlvFhZV8LbSt1CwaJBZ
    q1tgd5R9ASWiR9zNhOWBdubPY1EFEQDraNzNAw1grU4kJF1pP+zpxjQpnDbDMR/z
    x+XV67zophZ0xbxUhMU7o3kwdzASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQW
    BBQmRi4w2U+nejgxiH8zUaNifrX6qDALBgNVHQ8EBAMCAQYwNQYDVR0fBC4wLDAq
    oCigJoYkaHR0cDovL2NhLmltbG9uZ2hhby5jb20vY3JsL3Jvb3QuY3JsMAoGCCqG
    SM49BAMCA2kAMGYCMQDhaynSLHycHAy56Lk8lCqYOK6JkHNm9pkULfxlaXwGTzEh
    v0+BQLO/9ao+CFuJ2KUCMQD2TGcTbHx0pxClJ0t+CeyTU5vUo5Yd6r1YJK75btIZ
    0nu4yY/alEEPQgy616SLlak=
    -----END CERTIFICATE-----
  '';
{
  environment.etc."mtr.sb/worker.hcl".text = ''
    cert_path = "/persist/mtr.sb/${config.networking.hostName}.crt"
    key_path = "/persist/mtr.sb/${config.networking.hostName}.pem"
    server_ca_path = ${ca}
  '';
  services.mtrsb = {
    enable = true;
  };
}
