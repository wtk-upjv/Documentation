## Exclude interface in network manager

- [Red Hat - Configuring NetworkManager to ignore certain devices](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-networkmanager-to-ignore-certain-devices_configuring-and-managing-networking)
- [Arch Linux - Ignore specific devices](https://wiki.archlinux.org/title/NetworkManager#Ignore_specific_devices)

Permanently:

```bash
# Find the MAC address of your device
ip -br link

# Create the configuration file
sudo mkdir -p /etc/NetworkManager/conf.d

cat << EOF | sude tee /etc/NetworkManager/conf.d/99-unmanaged-devices.conf
[keyfile]
unmanaged-devices=mac:00:e0:4c:68:07:0c
EOF

# Reload NetworkManager
sudo nmcli general reload
```

Temporarily (until the device is reconnected):

```bash
nmcli device set enp1s0 managed off
```

Verification:

```bash
nmcli device status
```
