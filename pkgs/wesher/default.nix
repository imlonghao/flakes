{ sources, buildGoModule, lib }:

buildGoModule rec {
  inherit (sources.wesher) pname version src vendorHash;

  meta = with lib; {
    description = "wireguard overlay mesh network manager";
    homepage = "https://github.com/costela/wesher";
    license = licenses.gpl3Plus;
  };
}
