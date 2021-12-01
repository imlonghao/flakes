#!/bin/sh
set -e
set -x

env

cat << EOF > /tmp/config_test
experimental-features = nix-command flakes
system-features = nixos-test benchmark big-parallel kvm recursive-nix
substituters = https://imlonghao.cachix.org https://nrdxp.cachix.org https://nix-community.cachix.org https://cache.nixos.org
trusted-public-keys = imlonghao.cachix.org-1:KGQ7+R1BXo2NsoeAxKLPfGAiHz5ofCmZO4hih7u/2Q8= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=      
EOF

export USER=builder
export INPUT_EXTRA_NIX_CONFIG="`cat /tmp/config_test`"
export INPUT_INSTALL_URL=https://github.com/numtide/nix-flakes-installer/releases/download/nix-2.5pre20211026_5667822/install
export GITHUB_ENV=/dev/null
export GITHUB_PATH=/dev/null
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/var/nix/profiles/default/bin

useradd -md /home/$USER $USER
apt update && apt install -y sudo git curl xz-utils
curl -L https://git.esd.cc/mirrors/install-nix-action/raw/commit/ea25556f17ea29b5259072fb3638214584088665/lib/install-nix.sh | INPUT_INSTALL_OPTIONS= INPUT_NIX_PATH= bash
nix-env -iA cachix -f https://cachix.org/api/v1/install
curl -o /tmp/push-paths.sh https://git.esd.cc/mirrors/cachix-action/raw/commit/3db1a09d3a573d7b62801116405ad5aa0f59c904/dist/main/push-paths.sh
curl -o /tmp/list-nix-store.sh https://git.esd.cc/mirrors/cachix-action/raw/commit/3db1a09d3a573d7b62801116405ad5aa0f59c904/dist/main/list-nix-store.sh
chmod +x /tmp/push-paths.sh /tmp/list-nix-store.sh
/tmp/list-nix-store.sh > /tmp/store-path-pre-build
nix -Lv build ".#rait"
nix -Lv build ".#pingfinder"
nix -Lv develop -c echo OK
