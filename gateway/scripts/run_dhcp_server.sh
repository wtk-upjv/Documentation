#!/usr/bin/env bash

set -e
set -u

sudo dnsmasq --conf-file=configs/dnsmasq.conf --no-daemon
