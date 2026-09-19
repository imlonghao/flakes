#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: update_pkgs.sh [PACKAGE ...]

Update all packages in pkgs/, or only the named packages.
Packages requiring manual updates are reported as skipped.
NIX_UPDATE_SYSTEM overrides the target system (default: native Linux,
or x86_64-linux on macOS). Linux dependency builds require a Linux builder.
EOF
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  usage
  exit 0
fi

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

packages=("$@")
if [[ $# -eq 0 ]]; then
  for file in pkgs/*/package.nix; do
    [[ -f $file ]] || continue
    package=${file#pkgs/}
    packages+=("${package%/package.nix}")
  done
fi

# Validate every argument before updating any files.
for package in "${packages[@]}"; do
  if [[ ! $package =~ ^[a-zA-Z0-9_][a-zA-Z0-9_-]*$ ]] ||
    [[ ! -f pkgs/$package/package.nix ]]; then
    printf 'Unknown package: %s\n' "$package" >&2
    exit 2
  fi
done

system=${NIX_UPDATE_SYSTEM:-}
if [[ -z $system ]]; then
  system=$(nix eval --impure --raw --expr builtins.currentSystem)
  case "$system" in
    *-darwin) system=x86_64-linux ;;
  esac
fi

failed=()
skipped=()
for package in "${packages[@]}"; do
  args=(--flake --system "$system")
  reason=
  case "$package" in
    hachimi|supervxlan)
      args+=(--version=branch)
      ;;
    dn42debug)
      reason='local source; no upstream version'
      ;;
    lotspeed)
      reason='pinned zeta-tcp commit; select the intended revision manually'
      ;;
    peerfinder-agent)
      reason='unversioned download URL; check version and source hash manually'
      ;;
  esac

  if [[ -n $reason ]]; then
    printf 'Skipping %s: %s\n' "$package" "$reason"
    skipped+=("$package")
    continue
  fi

  printf '\nUpdating %s (%s)\n' "$package" "$system"
  if ! nix-update "${args[@]}" "$package"; then
    failed+=("$package")
  fi
done

if [[ ${#skipped[@]} -gt 0 ]]; then
  printf '\nSkipped (manual update required): %s\n' "${skipped[*]}"
fi
if [[ ${#failed[@]} -gt 0 ]]; then
  printf '\nFailed: %s\n' "${failed[*]}" >&2
  printf 'Failed updates may leave partial edits; inspect git diff.\n' >&2
  exit 1
fi
