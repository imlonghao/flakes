#!/bin/bash
set -euo pipefail

export ROLE_ID='xxx'
export SECRET_ID='xxx'
BAO_ADDR='https://openbao.esd.cc'
BAO_NAMESPACE='imlonghao'

bao_token=$(
  jq -n '{role_id: env.ROLE_ID, secret_id: env.SECRET_ID}' \
    | curl -qfsS --max-time 60 -H "X-Vault-Namespace: $BAO_NAMESPACE" \
      -H 'Content-Type: application/json' --data-binary @- "$BAO_ADDR/v1/auth/approle/login" \
    | jq -er '.auth.client_token | strings | select(length > 0)'
)
unset ROLE_ID SECRET_ID

bao_get() {
  printf 'X-Vault-Token: %s\n' "$bao_token" \
    | curl -qfsS --max-time 60 -H "X-Vault-Namespace: $BAO_NAMESPACE" \
      -H @- "$BAO_ADDR/v1/$1"
}

kv_version=$(bao_get sys/internal/ui/mounts/kv | jq -er '.data.options.version // "1"')
kv_path=kv
if [ "$kv_version" = 2 ]; then
  kv_path=kv/data
fi

mkdir -p /persist/certs
cd /persist/certs
work_dir=$(mktemp -d .cert-syncer.XXXXXX)
trap 'rm -rf -- "$work_dir"' EXIT

for certificateName in esd.cc; do
  bao_get "$kv_path/certs/$certificateName" | jq -e '.data.data // .data' > "$work_dir/raw"
  jq -er '.crt | strings | select(length > 0)' "$work_dir/raw" > "$work_dir/crt"
  jq -er '.key | strings | select(length > 0)' "$work_dir/raw" > "$work_dir/key"

  if ! cmp -s "$work_dir/crt" "$certificateName.crt" \
    || ! cmp -s "$work_dir/key" "$certificateName.key"; then
    mv "$work_dir/crt" "$certificateName.crt"
    mv "$work_dir/key" "$certificateName.key"
    docker restart traefik
  fi
done
