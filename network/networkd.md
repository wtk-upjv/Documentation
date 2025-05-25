# Setup the batman interface using systemd-networkd

Batman sources:

- +++ Tutorial batman and netplan (systemd-networkd): <https://gist.github.com/requinix/4167ac09242684ac23f484543ac8bbcd>
- News systemd batman support: <https://www.open-mesh.org/news/101>

Debian sources:

- Debian official manual network setup: <https://www.debian.org/doc/manuals/debian-reference/ch05.en.html>
- Debian wiki systemd-networkd: <https://wiki.debian.org/SystemdNetworkd>

Networkd manuals:

- Batman interface <https://www.freedesktop.org/software/systemd/man/latest/systemd.netdev.html#[BatmanAdvanced]%20Section%20Options>
- Batman network <https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html#BatmanAdvanced=>

## Disable NetworkManager

```bash
systemctl disable --now NetworkManager
```

## Configuration files

`/etc/systemd/network/10-bat0.netdev`:

```ini
[NetDev]
# Create a new network device
Name=bat0
Kind=batadv

[BatmanAdvanced]
# Use batman-iv for compatibility issues
# RoutingAlgorithm=batman-iv
RoutingAlgorithm=batman-v
```

`/etc/systemd/network/10-bat0.network`:

```ini
[Match]
# Apply this configuration to the bat0 device
Name=bat0

[Link]
# Decreate the MTU of bat0 to include the batman header
MTUBytes=1468

[Network]
# Link-local autoconfiguration (ipv4 and ipv6)
LinkLocalAddressing=yes
# Use DHCP to access internet (development mode)
DHCP=ipv4

[Route]
# Add a multicast route with a low metric value so bat0 is the default
Destination=ff00::/8
Metric=100
Table=local
Type=multicast
```

`/etc/systemd/network/10-bat0-interfaces.network` (could be split in two for each interface):

```ini
[Match]
# Apply to all of these interfaces, separated by spaces
Name=eth0 wlan0
# Use only wlan ad-hoc interfaces (excluding eth0)
# WLANInterfaceType=ad-hoc

[Link]
# Disable link-local addressing on other interfaces than bat0
LinkLocalAddressing=no

# Increase the MTU because batman-adv uses slightly larger packets than normal
# Not supported on the Raspberry PI 3 for both interfaces
# Decrease the MTU of the bat0 network instead
#MTUBytes=1532

[Network]
# Assign to bat0
BatmanAdvanced=bat0
```

## Configure the wlan interface

[Configure the wlan interface](./wpa_supplicant.md) with `wpa_supplicant`. Start the service:

```bash
sudo systemctl enable --now wpa_supplicant@wlan0.service
```

## Manage `systemd-networkd`

Enable and start `systemd-networkd`:

```bash
systemctl enable --now systemd-networkd
```

Reload the configuration:

```bash
systemctl reload systemd-netword
```
