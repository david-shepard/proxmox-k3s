#!/bin/bash


if [[ "$#" != 2 ]]; then
  echo "Usage $0  <config path> <hostname>"
  echo "Example $0 ../config/pve-sample.conf k3s-node"
  exit 1
fi

mapfile -t configs < <(ls -1 /etc/pve/lxc/)
last_config="${configs[-1]%%.*}"
new_config=$((last_config+1))

# make sure you've downloaded ubuntu-20.04-standard_20.04.1-1_amd64.tar.gz to the host
pct create "$new_config" local:vztmpl/ubuntu-20.04-standard_20.04.1-1_amd64.tar.gz \
--config "$1" \
--hostname "$2"