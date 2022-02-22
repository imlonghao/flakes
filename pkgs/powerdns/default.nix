{ lib, stdenv, fetchurl, pkg-config, nixosTests
, boost, libyamlcpp, libsodium, sqlite, protobuf, openssl, systemd
, mariadb-connector-c, postgresql, lua, openldap, geoip, curl, unixODBC
}:

stdenv.mkDerivation rec {
  pname = "powerdns";
  version = "4.6.0";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "sha256-ue/7eWinutu5HupDHHM0ZIKmdZJoTYRmDt2LdSjMEyU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost mariadb-connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl unixODBC openssl systemd
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=gmysql pipe remote"
      --with-sqlite3
      --with-libcrypto=${openssl.dev}
      --with-libsodium
      --enable-tools
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-reproducible
      --enable-unit-tests
      --enable-systemd
    )
  '';

  enableParallelBuilding = true;
  doCheck = true;

  passthru.tests = {
    nixos = nixosTests.powerdns;
  };

  meta = with lib; {
    description = "Authoritative DNS server";
    homepage = "https://www.powerdns.com";
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 disassembler ];
  };
}
