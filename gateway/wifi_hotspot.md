# WIFI hotspot

## linux-wifi-hotspot

<https://github.com/lakinduakash/linux-wifi-hotspot>

Automatic hotspot + DHCP server + NAT + port forwarding:

```bash
create_ap wlp1s0 wlp1s0 wtk-hotspot "pass_phrase"
```

## Manual

<https://wiki.archlinux.org/title/Software_access_point>

### Hotspot only

Disable your wifi device in NetworkManager.

Then run hostapd in a separate terminal:

```bash
sudo hostapd hostapd.conf
```

### Hotspot + Internet

<https://wiki.archlinux.org/title/Talk:Software_access_point#Two_interfaces_on_same_card>

> Warning: Its difficult!

You need to have two interefaces on the same card (hotspot + Internet).

Connect your wifi device with NetworkManager to the Internet.

Then create a virtual device:

```bash
WIFI_IFACE=""
NEW_MACADDR=""

# Create virtual device
iw dev wlan0 interface add ${WIFI_IFACE} type __ap

# Set managed off in NetworkManager
nmcli device set ${WIFI_IFACE} managed off

# Set new MAC address 
ip link set dev ${WIFI_IFACE} address ${NEW_MACADDR}

# Set the IPv4 address
ip link set down dev ${WIFI_IFACE}
ip addr flush wtk_ap
ip link set up dev wtk_ap
ip addr add 192.168.5.1/24 dev wtk_ap
```

In `hostapd.conf`, the channel must be the same than the Internet device!

Finally run `hostapd` with the virtual device. 
