{ sources, buildGoModule, lib }:

buildGoModule rec {
  inherit (sources.wesher) pname version src vendorSha256;

  meta = with lib; {
    description = "wireguard overlay mesh network manager";
    homepage = "https://github.com/costela/wesher";
    license = licenses.gpl3Plus;
  };
}
