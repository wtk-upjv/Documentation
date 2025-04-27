## Résumé

Un guide pas-à-pas pour configurer **BATMAN-adv en IPv4 et IPv6** sur deux Raspberry Pi tournant sous **Raspberry Pi OS 64 bits** (Bullseye/Bookworm).

Contrairement à la version « Legacy », qui utilisait `/etc/network/interfaces`, nous exploiterons la gestion réseau moderne via **systemd-networkd**.

Ce guide montre comment installer et charger le module, créer l’interface `bat0`, lui attribuer des adresses IPv4 Link-Local et IPv6 Link-Local automatiquement, et tester le maillage.

---

## 2. Installation de BATMAN-adv

Sur chaque Raspberry Pi, exécuter :
```bash
sudo apt update
sudo apt install batctl
```

- **batctl** est l’outil pour administrer BATMAN-adv.

---

## 3. Chargement automatique du module au démarrage

Créer un fichier pour charger `batman_adv` au boot :

```bash
echo batman_adv | sudo tee /etc/modules-load.d/batman-adv.conf
```

Vérifier qu’il est bien présent :

```bash
ls /etc/modules-load.d/ | grep batman-adv
```

---

## 4. Création et configuration de l’interface bat0

### Via systemd-networkd

1. Désactiver `dhcpcd` sur bat0 (si existant) :
```bash
sudo mv /etc/systemd/network/99-dhcp-bat0.network /etc/systemd/network/
```

2. Créer `/etc/systemd/network/30-bat0.netdev` :
```ini
[NetDev]
Name=bat0
Kind=batadv
```

3. Créer `/etc/systemd/network/30-bat0.network` :
```ini
[Match]
Name=bat0

[Network]
# Configuration automatique Link-Local
LinkLocalAddressing=ipv4
LinkLocalAddressing=ipv6

[Link]
RequiredForOnline=yes

[PreUp]
Exec=/usr/sbin/batctl if add wlan0
```

4. Activer et redémarrer :
```bash
sudo reboot

# Vérifier adresses
ip -4 a show bat0   # IPv4 169.254.x.x
ip -6 a show bat0   # IPv6 fe80::/64
```

---

## 5. Adresses IPv4 et IPv6 statiques (optionnel)

Pour des IP fixes, remplacer la section `[Network]` par :
```ini
[Network]
Address=192.168.50.1/24   # IPv4
Address=fd00::1/64       # IPv6
```

- Sur **isri** :
    - `Address=192.168.50.1/24`
    - `Address=fd00::1/64`
- Sur **isri2** :
    - `Address=192.168.50.2/24`
    - `Address=fd00::2/64`

---
## 6. Vérifications et tests

1. Vérifier le module :
```bash
lsmod | grep batman_adv || sudo modprobe batman_adv
```

2. Vérifier l’interface :
```bash
ip link show bat0
```

3. Tester le ping IPv4 et IPv6 :
```bash
ping -I bat0 <IPv4>
ping6 -I bat0 <IPv6>
```

---

## 7. Conseils et dépannage

- **Wi-Fi** : passer en mode ad-hoc si pas de point d’accès :
```bash
iw dev wlan0 set type ibss
```

- **Logs** :
```bash
journalctl -u systemd-networkd
dmesg | grep batadv
```