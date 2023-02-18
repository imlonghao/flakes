{ autoreconfHook, sources, lib, stdenv, fetchurl, flex, bison, readline, libssh }:

stdenv.mkDerivation rec {
  inherit (sources.mybird) pname version src;

  nativeBuildInputs = [ autoreconfHook flex bison ];
  buildInputs = [ readline libssh ];

  patches = [
    ./dont-create-sysconfdir-2.patch
  ];

  CPP="${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  meta = with lib; {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "http://bird.network.cz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.linux;
  };
}
