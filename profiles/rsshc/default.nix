{ pkgs, ... }:
let
  ca = pkgs.writeText "ca.crt" ''
    -----BEGIN CERTIFICATE-----
    MIIBozCCAUqgAwIBAgIRAPNyvyHMBh1vgQFB9R/gDOowCgYIKoZIzj0EAwIwMDES
    MBAGA1UEChMJaW1sb25naGFvMRowGAYDVQQDExFpbWxvbmdoYW8gUm9vdCBDQTAe
    Fw0yMzEyMTAxMTI0NTRaFw0zMzEyMDcxMTI0NTRaMDAxEjAQBgNVBAoTCWltbG9u
    Z2hhbzEaMBgGA1UEAxMRaW1sb25naGFvIFJvb3QgQ0EwWTATBgcqhkjOPQIBBggq
    hkjOPQMBBwNCAAQHAdWXqylu6Yn9NtnE/K3l7vL0cQbMEYd/Rti+2l5m+UVW37jB
    ERA5NCym/xq4q0oflcEOr04xjtXP4kAMjb/To0UwQzAOBgNVHQ8BAf8EBAMCAQYw
    EgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQUw+daBEc1HLovYD1n0lZjDXk7
    sIkwCgYIKoZIzj0EAwIDRwAwRAIgQz5bAOfSGLHliTwMIsP7N9ZeGOq9d1+BEm1F
    gv7EeZ4CIHFAg1O33OZ40uyet9XoSSLH44OCUmByJ5OItY4kJyml
    -----END CERTIFICATE-----
  '';
in {
  services.openssh.extraConfig = ''
    HostCertificate /persist/etc/ssh/step-cert.pub
  '';
  services.rsshc = {
    enable = true;
    path = "${ca}";
  };
}
