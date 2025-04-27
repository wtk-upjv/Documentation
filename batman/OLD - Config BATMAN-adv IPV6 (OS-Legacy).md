## 1. **Choix de l'OS**

Il est recommandé d'utiliser une distribution compatible avec le fichier **/etc/network/interfaces**, comme **Raspbian Lite Legacy (64-bit)**, pour que la gestion via ce fichier fonctionne correctement. 

Si on utilise une version moderne (par exemple, Raspbian Buster ou Bullseye), il est possible que la gestion réseau se fasse via **dhcpcd.conf** ou **Network Manager**.

La version Legacy maintient l'ancienne méthode via `/etc/network/interfaces`, ce qui est utilisé sur cette configuration.

---

## 2. **Installation de BATMAN-adv et des outils nécessaires**

Se connecter su chaque raspberry en tant qu’utilisateur pour executer les commandes suivantes pour installer **batctl** :
```bash
sudo apt update
sudo apt install batctl
```

Cela installera **batctl**, l'outil de gestion et de contrôle du maillage **BATMAN-adv**.

---
## 3. **Chargement du module BATMAN-adv**

Pour que le module **BATMAN-adv** soit chargé automatiquement au démarrage, on edite le fichier **/etc/modules** :
```bash
sudo nano /etc/modules
```

On ajoute la ligne suivante à la fin du fichier :
```
batman-adv
```

---
## 4. **Configuration de l’interface réseau en IPv6**

### A. **Configuration via le fichier `/etc/network/interfaces`**

Pour que le système crée l’interface virtuelle **bat0** et la lie à l’interface sans fil (ici supposée être **wlan0**), on edite le fichier **/etc/network/interfaces** :
```bash
sudo nano /etc/network/interfaces
```

Ajoutez la configuration suivante :

```bash
auto bat0
iface bat0 inet6 auto
    pre-up /usr/sbin/batctl if add wlan0
```

**Explications :**
- `auto bat0` : L’interface **bat0** sera automatiquement activée au démarrage.
- `iface bat0 inet6 auto` : Configure **bat0** en IPv6 avec autoconfiguration.
- La ligne `pre-up /usr/sbin/batctl if add wlan0` permet d’ajouter l’interface **wlan0** dans le réseau maillé avant la montée de l’interface **bat0**.

> **Note :**  
> Faut adapter la configuration réseau si les interfaces sans fil portent un nom différent (par exemple, **wlan1** ou un nom généré par **predictable network interface names**).

### B. **Attribution d'adresses IPv6 statiques (Optionnel)**

**Sur le fichier de configuration /etc/network/interfaces** :

```bash
auto bat0
iface bat0 inet6 static
    address <Adresse IPV6>
    netmask 64
    pre-up /usr/sbin/batctl if add wlan0
```

---

## 5. **Vérification du module BATMAN-adv**

- On s'assure que le module **batman-adv** est bien chargé en exécutant :
```bash
lsmod | grep batman_adv
```

- **Si ce n'est pas le cas**, on peut le charger manuellement :
```bash
sudo modprobe batman-adv
```

- Pour que le module se charge automatiquement au démarrage, on verifie que **batman-adv** figure bien dans le fichier **/etc/modules**.

---
## 6. **Redémarrage et vérification du maillage**

Après avoir effectué ces modifications sur les Raspberry Pi :

1. **On redémarre le système** 
```bash
    sudo reboot
 ```

2. **On verifie que l'interface `bat0` est bien montée** sur chaque Raspberry Pi :
```bash
    ip a show bat0
```
1. **On teste la connectivité entre les nœuds** en utilisant **batctl** :
```bash
    sudo batctl o
```
Cette commande doit afficher l’autre nœud du maillage. On peut aussi utiliser `ping6` si on opte pour des adresses IPv6 statiques pour tester la connectivité entre les deux Raspberry Pi.

---

Test Ping pi1 vers pi2 :
```bash
ping6 <IP> -I bat0
```

---