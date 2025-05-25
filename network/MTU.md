# MTU in batman

- Checking maximum MTU using `ping`: <https://dba010.com/2025/03/20/checking-supported-mtu-maximum-transmission-unit-for-a-system-using-ping/>
- Batman recommended MTU: <https://www.open-mesh.org/projects/batman-adv/wiki/Quick-start-guide#Simple-mesh-network>
- Batman fragmentation: <https://www.open-mesh.org/projects/batman-adv/wiki/Fragmentation-technical>
- `batctl` tcpdump and statistics: <https://github.com/open-mesh-mirror/batctl>

## Setting the MTU

Batman recommends setting the MTU of interfaces to 1532 or the MTU of bat0 to 1468.

Other documents suggest to set the MTU to 1528. The 32 header for Batman is not an absolute value.

Setting the MTU to 1468:

```bash
ip link set up mtu 1468 dev bat0
```

## Testing

Open `wireshark` to listen to the interface added to `bat0`: `wlp1s0` or `wlan0` (don't use the interface `bat0`)

Add the filters:

- `icmp`
- The batman unicast fragmented packet type `batadv.batman.packet_type == 65`

`enp3s0f3u2u4` is the single interface added to the mesh network. Initially, the MTU values are:

```text
7: enp3s0f3u2u4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bat0 state UP group default qlen 1000
8: bat0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
```

Maximum with fragmentation:

```bash
# -M do   = don't fragment (else error)
# -s 1472 = data size
ping 192.168.0.254 -s 1472 -M do
```
```text
Result:
- 1472 + 8  = 1480 (ICMP)
- 1480 + 20 = 1500 (IP) <= MTU
- 1500 + 14 = 1514 (Ethernet)
- 1514 + 10 = 1524 (Batman unicast)
- size > 1514 => fragmentaion

Frame 1:
- 762  + 20 = 782  (Batman unicast fragmented)
- 792  + 14 = 796  (Ethernet)
- OK <= 1514

Frame 2:
- 762  + 20 = 782  (Batman unicast fragmented)
- 792  + 14 = 796  (Ethernet)
- OK <= 1514
```

Maximum without fragmentation:

```bash
ping 192.168.0.254 -s 1448 -M do
```
```text
Result:
- 1448 + 8  = 1456 (ICMP)
- 1456 + 20 = 1476 (IP)
- 1476 + 14 = 1590 (Ethernet)
- 1490 + 10 = 1500 (Batman unicast)
- 1500 + 14 = 1514 (Ethernet)
- OK <= 1514
```

Changing the MTU to the recommended value and maximum without fragmentation:


```bash
ip link set up mtu 1468 dev bat0
```
```text
8: bat0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1468 qdisc noqueue state UNKNOWN group default qlen 1000
```
```bash
ping 192.168.0.254 -s 1440 -M do
```
```text
Result:
- 1440 + 8  = 1448 (ICMP)
- 1448 + 20 = 1468 (IP) <= MTU
- 1468 + 14 = 1482 (Ethernet)
- 1482 + 10 = 1492 (Batman unicast)
- 1492 + 14 = 1506 (Ethernet)
- OK <= 1514
```
