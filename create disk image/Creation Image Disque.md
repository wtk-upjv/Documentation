Parfait, merci pour la précision ! Donc tu as :

-  **Une clé USB bootable** contenant **Raspberry Pi OS + WTK installé/configuré**.
- Cette clé est **déjà fonctionnelle sur une Raspberry Pi** (probablement en boot USB).
- Objectif :** créer une image de cette clé USB pour la cloner facilement ailleurs = un système Plug & Play avec WTK au démarrage.

---

## Résumé des étapes à suivre

### 1. Identifier la clé USB

Sur un autre Linux (PC ou RPi avec un autre disque), branche la clé USB et exécute :

```bash
lsblk
```

Repère bien le nom du périphérique (ex. `/dev/sda` ou `/dev/sdb`). 
⚠️ Ne pas se tromper sinon ça va écraser

---

### 2. Créer une image de la clé USB

Ensuite, utilise `dd` pour en faire une image :

```bash
sudo dd if=/dev/sdX of=wtk_usb.img bs=4M status=progress
```

> Remplace `/dev/sdX` par la bonne valeur (ex. `/dev/sdb`).

Cette commande va créer un fichier `wtk_usb.img`, une **copie bit à bit de ta clé USB**.

---

### 3. (Optionnel) Compresser l’image

Pour stocker ou transférer plus facilement l’image :

```bash
xz -z -9 wtk_usb.img
```

Tu obtiendras `wtk_usb.img.xz`.

---

### 4. Flasher l’image sur une autre clé

Pour reproduire le système Plug & Play sur une autre clé USB ou carte SD :

```bash
sudo dd if=wtk_usb.img of=/dev/sdX bs=4M status=progress
```

> Même chose : `/dev/sdX` est le nom de ta nouvelle clé.

---

## Vérification au boot

Faut s'assusser sur :

- Le fichier `cmdline.txt` ou `fstab` dans la partition boot ou root ne dépend **pas d’un UUID fixe**
- Sinon, les modifier pour que le système accepte d’autres supports USB (UUID dynamique ou `/dev/sda1`)