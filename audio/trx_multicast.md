## IPv6 multicast

IPv6 multicast requires to subscribe explicitly to the multicast group:

- Set the address, port and interface used by `trx-rx`

```python
import socket
import struct

MULTICAST_GROUP = 'ff12::1234'
IFACE = 'bat0'

# Create socket
sock = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)

# Get the address in binary format
group_bin = socket.inet_pton(socket.AF_INET6, MULTICAST_GROUP)

# Get the interface index in binay format
iface_index = socket.if_nametoindex(IFACE)
iface_index_bin = struct.pack('@i', iface_index)

# Create a multicast request and set the option in the socket
ipv6_mreq = group_bin + iface_index_bin
sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_JOIN_GROUP, ipv6_mreq)
```

Look at the manual and headers for information:

- `man 7 setsockopt`
- `man 7 socket`
- `man 7 ipv6`
- `man 7 ip`

`ipv6_mreq` structure:

```c
// In the file /usr/src/kernel-headers-6.12.25_1/include/uapi/linux/in6.h
struct ipv6_mreq {
        /* IPv6 multicast address of group */
        struct in6_addr ipv6mr_multiaddr;

        /* local IPv6 address of interface */
        int             ipv6mr_ifindex;
};
```

## IPv4 multicast (done automatically by trx)

UPD multicast in python: <https://stackoverflow.com/questions/603852/how-do-you-udp-multicast-in-python>

```python
from socket import *

multicast_group = "239.0.56.2"
interface_ip    = "192.168.5.1"

socket = socket(AF_INET, SOCK_DGRAM )
mreq = inet_aton(multicast_group) + inet_aton(interface_ip)
socket.setsockopt(IPPROTO_IP, IP_ADD_MEMBERSHIP, mreq)
```
