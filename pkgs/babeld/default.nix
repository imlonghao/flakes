{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  inherit (sources.babeld) pname version src;

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  passthru.tests.babeld = nixosTests.babeld;

  meta = with lib; {
    homepage = "http://www.irif.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz hexa ];
    platforms = platforms.linux;
  };
}
