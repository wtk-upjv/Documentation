# wpa_supplicant

- +++ Autostart ad-hoc network: <https://raspberrypi.stackexchange.com/questions/94047/how-to-setup-an-unprotected-ad-hoc-ibss-network-and-if-possible-with-wpa-encry>
- Wireless networking with systemd <https://chiraag.me/wireless/>
- Archlinux forum WPA wireless with systemd <https://bbs.archlinux.org/viewtopic.php?pid=1393759#p1393759>


## Configuration

Encrypted IBSS is not supported on the Raspberry PI.

`/etc/wpa_supplicant/wpa_supplicant-wlan0.conf`:

```
# From /usr/share/doc/wpa_supplicant/examples/wpa_supplicant.conf

p2p_disabled=1
country=FR

# IBSS/ad-hoc network with RSN
network={
        ssid="wtk-mesh-network"
        mode=1
        frequency=2412
        key_mgmt=NONE
}
```

## Service

```bash
sudo systemctl enable --now wpa_supplicant@wlan0.service
```
