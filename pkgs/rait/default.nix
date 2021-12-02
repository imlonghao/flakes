{ sources, buildGoModule, fetchFromGitLab, lib }:

buildGoModule rec {
  inherit (sources.rait) pname version src vendorSha256;

  subPackages = [ "cmd/rait" ];

  postInstall = ''
    cat << EOF > $out/bin/rait.sh
    #!/bin/sh
    set -e

    \$WGET -q -O /tmp/rait.new https://repo.esd.cc/registry.json

    if [ ! -f /tmp/rait.old ]; then
        \$RAIT u -c /run/secrets/rait.conf
        mv /tmp/rait.new /tmp/rait.old
        exit 0
    fi

    \$CMP -s /tmp/rait.old /tmp/rait.new || (\$RAIT u -c /run/secrets/rait.conf && mv /tmp/rait.new /tmp/rait.old)
    EOF
    chmod +x $out/bin/rait.sh
  '';

  meta = with lib; {
    description = "Redundant Array of Inexpensive Tunnels";
    homepage = "https://gitlab.com/NickCao/RAIT";
    license = licenses.asl20;
  };
}
