## IPv6 multicast

IPv6 multicast requires to subscribe explicitly to the multicast group:

- Set the address, port and interface used by `trx-rx`

```python
import socket
import struct

MULTICAST_GROUP = 'ff12::1234'
PORT  = 1350
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
