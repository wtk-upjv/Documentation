#!/usr/bin/env bash

set -e
set -u

trap "cleanup" EXIT

cleanup() {
    echo ""
    echo "cleanup: destroy batctl interface"
    sudo batctl interface destroy || true
}

[ $# -ne 2 ] && echo "usage: $0 lan_interface out_interface" >&2 && exit 1

lan_interface="${1}"
out_interface="${2}"
batman_interface="bat0"

sudo batctl interface destroy || true
sudo batctl interface create routing_algo BATMAN_V
sudo batctl interface add "${lan_interface}"
sudo ip link set up mtu 1468 dev bat0
sudo ip link set up dev "${lan_interface}"

./set_gateway.sh "${batman_interface}" "${out_interface}"
./run_dhcp_server.sh
