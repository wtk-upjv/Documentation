## Introduction

- IBSS (Independent Basic Service Set) / ad-hoc network: The network is ad-hoc because it does not rely on pre-existing infrastructure

Install batman on Debian:

```bash
apt install batctl
```

The module kernel is loaded when the package is installed.
Save it in the file `/etc/modules-load.d/wtk.conf`, or run the command:

```bash
modeprobe batman-adv
```

## Wireless setup

- B.A.T.M.A.N. advanced quick start guide: <https://www.open-mesh.org/projects/batman-adv/wiki/Quick-start-guide>
- Linux wireless documentation iw: <https://wireless.docs.kernel.org/en/latest/en/users/documentation/iw.html>
- TP-Link Basic wireless concepts: <https://www.tp-link.com/us/configuration-guides/q_a_basic_wireless_concepts/>

Unblock the wlan device and disable it:

```bash
# Unblock the wlan device
rfkill unblock wlan

# Disable the Wi-Fi in NetworkManager
nmcli radio wifi off

# Bring down the interface
ip link set down dev wlan0
```

(**Not for PI3**) Create a new virtual IBSS device:

```bash
# Create a new wireiw dev wlan0 ibss join wtk-mesh-network 2412 fixed-freq 02:12:34:56:78:9Aless device from scratch
# (PI3 can't delete device: error 524)
iw dev wlan0 del

# The new device is of type ibss
# (PI3 can't create new virtual device)
iw phy phy0 interface add wlan0 type ibss

# Set the mtu 1532 to include the batman header of 32 bytes
# (PI3 limited to 1500)
ip link set up mtu 1532 dev wlan0
```

(**For PI3**) Edit the interface to be an IBSS device:

```bash
# Set the device type to ibss
iw wlan0 set type ibss
```

Join an IBSS network:

- `iw help ibss`
- `join` the IBSS cell with the given SSID, if it doesn't exist create it on the given frequency:

  - 2412 (canal 1)
  - fixed-freq (force using this frequency)
  - 02:12:34:56:78:9A (fixed bssid)

```bash
# Bring the interface UP
ip link set up dev wlan0

# Join the ibss network
iw dev wlan0 ibss join wtk-mesh-network 2412 fixed-freq 02:12:34:56:78:9A
```

Add the wireless device and activate the batman interface:

```bash
# Add the wireless device to batman
batctl if add wlan0

# Bring the batman interface up
ip link set up dev bat0
```

## Ethernet setup

```bash
# Add the ethernet device to batman
batctl if add eth0
```

## IPv4LL

Install the daemon `avahi-autoipd` to get an automatic IPv4 address configuration:

```bash
apt install avahi-autoipd
avahi-autoipd bat0
```

## Gateway

<https://www.open-mesh.org/projects/batman-adv/wiki/Gateways>

On the server node, run:

```bash
bactl gw_mode server
```

On the client nodes, run:

```bash
bactl gw_mode client
```

List the gateways:

```bash
bactl gateways
```

## DHCP client

Run the dhclient (in background) to request a DHCP server on the network:

```bash
dhclient bat0
```

If `avahi-autoipd` is installed, it will be automatically stopped:

- `man dhclient-script`
- `/etc/dhcp/dhclient-enter-hooks.d/avahi-autoipd`
- `/etc/dhcp/dhclient-exit-hooks.d/zzz_avahi-autoipd`

If `dhclient` failed to contact any DHCP servers for the specified interface,
then `avahi-autoipd` will be executed to get an IPv4LL.

## Debug commands

List the **direct** neighbors:

```bash
batctl neighbors
```

## Some links

- Tutorial batman Raspberry Pi 3: <https://github.com/NutellaTN/MeshNetwork>
- NetworkManager dispatcher for batman-adv: <https://gist.github.com/frafra/4952d8d1795b5732366cs>