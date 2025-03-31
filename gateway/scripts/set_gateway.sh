#!/bin/bash

set -e
set -u

[ $# -ne 2 ] && echo "usage: $0 lan_interface out_interface" >&2 && exit 1

# TODO: Add support for IPv6

lan_interface="${1}"
out_interface="${2}"

gateway_address="192.168.5.1/24"

if [ "${lan_interface}" ]; then
    echo "Gateway begin"

    sudo ip link set "${lan_interface}" down
    sudo ip addr flush dev "${lan_interface}"
    sudo ip link set "${lan_interface}" up
    sudo ip addr add "${gateway_address}" dev "${lan_interface}"

    echo "Gateway end"
else
    echo "No gateway interface"
fi

if [ "${out_interface}" ]; then
    echo "NAT begin"

    sudo nft add table nat
    sudo nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
    sudo nft add rule nat postrouting ip saddr "${gateway_address}" oif "${out_interface}"
    sudo nft add rule nat postrouting masquerade

    # TODO: There are missing rules for using iptables alternative
    # sudo iptables -t nat -A POSTROUTING -o "${out_interface}" -j MASQUERADE
 
    sudo sysctl --write net.ipv4.ip_forward=1

    echo "NAT end"
else
    echo "No output interface"
fi
