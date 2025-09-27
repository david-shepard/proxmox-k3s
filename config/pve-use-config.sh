#!/bin/bash


if [[ "$#" != 4 ]]; then
  echo "Usage $0  <config path> <hostname> <host ip> <gateway ip>"
  echo "Example $0 pve-sample.conf k3s-node 192.168.0.5 192.168.0.1"
  exit 1
fi

export HOST_IP="$2"
export GW_IP="$3"

envsubst < pve-sample.conf > tmp.yaml && mv tmp.yaml pve-sample.conf

mapfile -t configs < <(ls -1 /etc/pve/lxc/)
last_config="${configs[-1]%%.*}"
new_config=$((last_config+1))

# make sure you've downloaded ubuntu-20.04-standard_20.04.1-1_amd64.tar.gz to the host
pct create "$new_config" local:vztmpl/ubuntu-20.04-standard_20.04.1-1_amd64.tar.gz \
--config "$1" \
--hostname "$2"