user : isri
password : isri

**Il faut déconnecter le wifi avant (NetworkManager):**
```
sudo nmcli radio wifi off
sudo rfkill unblock wifi
```

On passe l’interface en mode ad-hoc (IBSS) :
```
sudo ip link set wlan0 down
sudo iw wlan0 set type ibss
sudo ip link set wlan0 up
```

On rejoint ou crée un réseau **IBSS** nommé **my-mesh-network** sur le canal 2412 MHz (canal 1 en 2.4GHz) :
```
sudo iw wlan0 ibss join my-mesh-network 2412
```

Ajout de l’interface wlan0 à batman-adv, puis activation des interfaces
```
sudo batctl if add wlan0
sudo ip link set up dev bat0
sudo ip link set up dev wlan0
```

Vérification que wlan0 est bien associée :
```
sudo batctl if
```

---

**Attribution des adresses ip pour chaque pi** 
```
isri 1 : 
sudo ip addr add 192.168.199.1/24 dev bat0

isri 2 : 
sudo ip addr add 192.168.199.2/24 dev bat0

isri 3 : 
sudo ip addr add 192.168.199.3/24 dev bat0
```


# Test batman
On peut ping chaque IP : 
```
ping 192.168.199.x
```

puis (on peut faire sans le ping aussi normalement),
```
Pour voir les voisins
sudo batctl n

Pour voir la table de routage
sudo batctl o
```


pour voir les voisins, réseau eth0 ou bat0
```
ip neigh ou arp -n
---
192.168.199.3 dev bat0 lladdr aa:35:2e:10:ba:ec STALE 
192.168.1.254 dev eth0 lladdr 20:66:cf:72:1b:ce STALE 
192.168.199.2 dev bat0 lladdr 5a:db:93:f2:48:1e STALE 
192.168.1.135 dev eth0 lladdr dc:cd:2f:c7:8a:e5 STALE 
192.168.1.158 dev eth0 lladdr ca:c8:70:49:ba:08 DELAY 
fe80::2266:cfff:fe72:1bce dev eth0 lladdr 20:66:cf:72:1b:ce router REACHABLE 
fe80::2266:cf13:3772:1bce dev eth0 lladdr 20:66:cf:72:1b:ce router STALE
```

on peut ping en broadcast dans le réseau :
```
ping -b 192.168.199.255
```