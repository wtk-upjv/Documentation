# Multicast routing

## IPv6 local interface

`libort` example uses the default interface with index 0:

```c
/* ./ortp/src/rtpsession_inet.c */
struct ipv6_mreq mreq;
mreq.ipv6mr_multiaddr = ((struct sockaddr_in6 *) res->ai_addr)->sin6_addr;
mreq.ipv6mr_interface = 0;
err = setsockopt(sock, IPPROTO_IPV6, IPV6_JOIN_GROUP, (SOCKET_OPTION_VALUE)&mreq, sizeof(mreq));
```

From the [IPv6 RFC 3493](https://datatracker.ietf.org/doc/rfc3493/), the binded interface is determined by the routing table:

```text
    The reception of multicast packets is controlled by the two
   setsockopt() options summarized below.  An error of EOPNOTSUPP is
   returned if these two options are used with getsockopt().

      IPV6_JOIN_GROUP

         Join a multicast group on a specified local interface.
         If the interface index is specified as 0,
         the kernel chooses the local interface.
         For example, some kernels look up the multicast group
         in the normal IPv6 routing table and use the resulting
         interface.

         Argument type: struct ipv6_mreq
```

## Get multicast route

Get the route for a multicast address

```bash
ip route get ff12::1000
```
```text
multicast ff12::1000 from :: dev eth0 table local proto kernel src fe80::ba27:ebff:fe30:4f10 metric 256 pref medium
```

By default, IPv4 multicast routes are the same than IPv4 unicast.

## Change default route multicast IPv6

List routes in the local table:

```bash
ip -6 route show table local
```
```
local ::1 dev lo proto kernel metric 0 pref medium
local fe80::1c26:a3ff:fe81:970e dev bat0 proto kernel metric 0 pref medium
local fe80::ba27:ebff:fe30:4f10 dev eth0 proto kernel metric 0 pref medium
local fe80::ba27:ebff:fe65:1a45 dev wlan0 proto kernel metric 0 pref medium
multicast ff00::/8 dev eth0 proto kernel metric 256 pref medium
multicast ff00::/8 dev bat0 proto kernel metric 256 pref medium
multicast ff00::/8 dev wlan0 proto kernel metric 256 pref medium
```

Add a route with higher priority

```
sudo ip route add multicast ff00::/8 dev bat0 table local metric 100
```
