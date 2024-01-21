{ sources, buildGoModule, fetchFromGitLab, lib }:

buildGoModule rec {
  pname = "rait";
  version = "278188c8bae13165aa70b6a2fbbb99101fd6f4cd";
  src = fetchgit {
    url = "https://gitlab.com/NickCao/RAIT";
    rev = "278188c8bae13165aa70b6a2fbbb99101fd6f4cd";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-6Y0s5/HUmWrZA6QmV5wYjB1M0Ab/jHM3TSruRpMRwtA=";
  };
  vendorHash = "sha256-T/ufC4mEXRBKgsmIk8jSCQva5Td0rnFHx3UIVV+t08k=";

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
