#!/usr/bin/env bash
#!nix shell --ignore-environment .#cacert .#nodejs .#git .#nix-update .#nix .#gnused .#findutils .#bash --command bash

set -euo pipefail

version=$(npm view @mariozechner/pi-coding-agent version)

# Update version and hashes
nix-update pi-coding-agent --version="$version" --generate-lockfile --flake

# nix-update can't update package-lock.json along with npmDepsHash
# TODO: Remove this workaround if nix-update can update package-lock.json along with npmDepsHash.
(nix-build --expr '((import ./.) { system = builtins.currentSystem; }).pi-coding-agent.npmDeps.overrideAttrs { outputHash = ""; outputHashAlgo = "sha256"; }' 2>&1 || true) \
| sed -nE '$s/ *got: *(sha256-[A-Za-z0-9+/=-]+).*/\1/p' \
| xargs -I{} sed -i 's|npmDepsHash = "sha256-[^"]*";|npmDepsHash = "{}";|' pkgs/by-name/pi/pi-coding-agent/package.nix
