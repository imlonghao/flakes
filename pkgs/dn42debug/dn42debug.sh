#!/bin/bash

protocol=$1
interface=$2

if [ -z "$1" ]; then
  echo Usage: $0 Protocol [Interface]
  exit 1
fi

asn=$(echo "$protocol"|tr -d AS|sed 's/v4//g'|sed 's/v6//g')
neighbor=$(birdc sh pro all "$protocol"|grep -F 'Neighbor address'|awk -F ': ' '{print $2}')
if [ -z "$interface" ]; then
  interface=$(echo "$neighbor"|awk -F '%' '{print $2}')
fi
if [ -z "$interface" ]; then
  interface=wg${asn:0-4}
fi
wg=$(wg show "$interface"|grep -F 'endpoint: '|awk -F ': ' '{print $2}')
if [ ! -z "$wg" ]; then
  endpoint_host=$(echo "$wg"|awk -F ':' '{for (i=1; i<NF; i++) printf "%s:", $i}'|tr -d '[]'|sed 's/:$//g')
  endpoint_port=$(echo "$wg"|awk -F ':' '{print $NF}')
fi
mtu=$(ip link show "$interface"|grep -F mtu|awk '{print $5}')

run () {
  echo "#" "$@"
  $@
  echo
}

run birdc sh pro all "$protocol"
run wg show "$interface"
run ip a s "$interface"
if [ ! -z "$wg" ]; then
  run timeout 30 tcpdump -i any -c 10 -n host "$endpoint_host" and port "$endpoint_port"
fi
run timeout 30 tcpdump -i "$interface" -c 10 -n
run ping -c 10 "$neighbor"
run ping -M do -s $(expr $mtu - 48) -c 3 "$neighbor"
