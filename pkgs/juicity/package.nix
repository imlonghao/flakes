{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "juicity";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "juicity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aTg2Xo2+3uxLTJ3MRC46FR/4qBs28IpT6K3KMb8i16s=";
  };

  vendorHash = "sha256-xTpT3Qjg2kAJynLaQLLMmoL/SzpguK2YrlWsq/NYrX4=";

  proxyVendor = true;

  ldflags = [ "-X=github.com/juicity/juicity/config.Version=${version}" ];

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/juicity-server
    install -Dm444 install/juicity-server.service $out/lib/systemd/system/juicity-server.service
    substituteInPlace $out/lib/systemd/system/juicity-server.service \
      --replace /usr/bin/juicity-server $out/bin/juicity-server \
      --replace /etc/juicity/server.json /run/secrets/juicity
  '';

  meta = with lib; {
    homepage = "https://github.com/juicity/juicity";
    description = "A quic-based proxy protocol";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ oluceps ];
  };
}
