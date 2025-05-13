# libortp

There are different versions of the `libort` (used by `trx`).

I write down the differences between the versions.

Get the source code from:

- Debian libotp developer <https://tracker.debian.org/pkg/ortp>
- Debian libotp git clone <https://salsa.debian.org/pkg-voip-team/linphone-stack/ortp>

## IPv6 RFC 3493

<https://datatracker.ietf.org/doc/rfc3493/>

```text
5.2 Sending and Receiving Multicast Packets

    ...

    struct ipv6_mreq {
        struct in6_addr ipv6mr_multiaddr; /* IPv6 multicast addr */
        unsigned int    ipv6mr_interface; /* interface index */
    };

    Note that to receive multicast datagrams a process must join the
    multicast group to which datagrams will be sent.  UDP applications
    must also bind the UDP port to which datagrams will be sent.  Some
    processes also bind the multicast group address to the socket, in
    addition to the port, to prevent other datagrams destined to that   <--
    same port from being delivered to the socket.
```

## 5.1.64 (Debian 12)

Command:

```bash
sudo -E trx-rx -m 32 -h 239.0.0.1
```

Joined multicast addresses:

```bash
$ ip -4 maddress
```
```txt
1:      lo
        inet  224.0.0.251
        inet  224.0.0.1
2:      eth0
        inet  224.0.0.1
3:      bat0
        inet  239.0.0.1 users 2
        inet  224.0.0.251
        inet  224.0.0.1
```

Bind the multicast group address 239.0.0.1:

```bash
sudo ss --udp --listening --numeric --processes
```
```text
State    Recv-Q   Send-Q     Local Address:Port      Peer Address:Port  Process
UNCONN   0        0              239.0.0.1:1350           0.0.0.0:*      users:(("trx-rx",pid=614,fd=3))
UNCONN   0        0              239.0.0.1:57794          0.0.0.0:*      users:(("trx-rx",pid=614,fd=4))
```

Conclusion: `libortp` joins the multicast group and then receives the datagrams of that address + port.

## 5.3.106 (Void Linux)

Command:

```bash
sudo -E trx-rx -m 32 -h 239.0.0.1
```

Bind to any group:

```bash
sudo ss --udp --listening --numeric --processes
```

```text
State    Recv-Q   Send-Q      Local Address:Port      Peer Address:Port  Process
UNCONN   0        0                 0.0.0.0:33392          0.0.0.0:*      users:(("rx",pid=31264,fd=4))
UNCONN   0        0                 0.0.0.0:1350           0.0.0.0:*      users:(("rx",pid=31264,fd=3))
```

Source code:

```c
/* ./ortp/src/rtpsession_inet.c */
if (isMulticast) {
    /* Multicast membership must be claimed before bind(), otherwise we take the risk of
     * getting our bind() rejected because the local unicast port is already used.
     * In this case we should not bind() to the multicast address itself, but to a local address.
     * Use ::0 or 0.0.0.0.
     */
    set_multicast_group(sock, addr);
    any = bctbx_name_to_addrinfo(res->ai_family, SOCK_DGRAM, res->ai_family == AF_INET6 ? "::0" : "0.0.0.0",
                                    *port);
}
*sock_family = res->ai_family;
err = bind(sock, any ? any->ai_addr : res->ai_addr, any ? (int)any->ai_addrlen : (int)res->ai_addrlen);
```

Conclusion: `libortp` joins the multicast group but receives **any multicast datagrams bind to that port** from multicast group joined by other processes (multiple `trx` running concurently with different multicast addresses).

Effectively, I have been able with one address to listen the stream of two different multicast addresses.
