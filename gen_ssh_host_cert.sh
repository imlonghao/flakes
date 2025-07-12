#!/usr/bin/env bash

MYTMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$MYTMPDIR"' EXIT

target="$1"

if [ -z "$target" ]; then
  echo "Usage: $0 hostname"
  exit 0
fi

ssh-keyscan "$target" | grep ed25519 | awk '{printf "%s %s", $2, $3}' > "$MYTMPDIR/ssh_host_ed25519_key.pub"
step ssh certificate --ca-url https://ca.esd.cc --root /nix/store/0m8vj70qibm55h07lazany0nshi5c31j-ca.crt --host --sign "$target" "$MYTMPDIR/ssh_host_ed25519_key.pub"
cat "$MYTMPDIR/ssh_host_ed25519_key-cert.pub"
scp "$MYTMPDIR/ssh_host_ed25519_key-cert.pub" "$target":/persist/etc/ssh/step-cert.pub
