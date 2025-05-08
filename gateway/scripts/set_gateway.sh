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

    # Delete the gateway address from any interface
    ip -brief address |
        grep "${gateway_address}" |
        cut -d " " -f 1 |
        xargs -I {} sudo ip addr del "${gateway_address}" dev {}

    # Configure the new lan interface
    sudo ip link set "${lan_interface}" down
    sudo ip addr flush dev "${lan_interface}"
    sudo ip addr add "${gateway_address}" dev "${lan_interface}"
    sudo ip link set "${lan_interface}" up

    echo "Gateway end"
else
    echo "No gateway interface"
fi

if [ "${out_interface}" ]; then
    echo "NAT begin"

    # Delete the previous table if it exists
    sudo nft delete table wtk-nat 2>/dev/null && echo "NAT delete table" || true

    # Create the nat table
    echo "NAT create table"
    sudo nft add table wtk-nat
    sudo nft 'add chain wtk-nat postrouting { type nat hook postrouting priority 100 ; }'
    sudo nft add rule wtk-nat postrouting masquerade
    sudo nft add rule wtk-nat postrouting ip saddr "${gateway_address}" oif "${out_interface}"

    # TODO: There are missing rules for using iptables alternative
    # sudo iptables -t nat -A POSTROUTING -o "${out_interface}" -j MASQUERADE
 
    sudo sysctl --write net.ipv4.ip_forward=1

    echo "NAT end"
else
    echo "No output interface"
fi
