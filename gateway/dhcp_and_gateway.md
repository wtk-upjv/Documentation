## DHCP and DNS server

Run dnsmasq in a separate terminal:

```bash
sudo dnsmasq --conf-file=dnsmasq.conf --no-daemon
```

Several instances of `dnsmasq` can run if they bind the address of individal interfaces:

- `bind-interfaces` to staticaly bind **existing** interfaces. It continues to listen to the same addresses even when interfaces come and go and change address. Interfaces and addresses must exist.
- `bind-dynamic` to dynamicaly bind interfaces and automatically listen new ones. If new interfaces or addresses appeared, it automatically listens on those. Interfaces and addresses may not exist.

## NAT and port forwarding

Forward the traffic to the gateway:

```bash
lan_interface=""
out_interface=""
./set_gateway.sh "${lan_interface}" "${out_interface}"
```

## Debug

List the hosts on the local network:

```bash
# Print ARP table
cat /proc/net/arp

# Print ARP table
arp --numeric

# Send ARP requests
arp-scan -I enp3s0f3u2u3 --localnet
```

List listening sockets:

```bash
# ss --listening --tcp --numeric --processes
watch sudo ss -ltnp
```

List the open files of a process:

```bash
# -a: AND all the options
# -i: Internet network files
# -p: Select the list of files of the list of processes
# -n: No address translation
# -P: No port translation
sudo lsof -a -i -p 16280 -n -P
```
