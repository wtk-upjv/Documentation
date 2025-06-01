Author: @anto-nainFR

```bash
# port de base de trx : 1350, peut être modifié avec l'option -p

DEVICE=`ls /dev/input/by-id/usb*kbd`
KEY_CODE="KEY_LEFTCTRL"

sudo evtest "$DEVICE" | while read line; do
    if echo "$line" | grep -q "$KEY_CODE.*value 1"; then
        echo "Touche enfoncée"
        # permet de refuser les paquets UDP avec le port 1350
        sudo ip6tables -D OUTPUT -o bat0 -p udp --dport 1350 -j DROP
    elif echo "$line" | grep -q "$KEY_CODE.*value 0"; then
        echo "Touche relâchée"
        # permet d'accepter les paquets UDP avec le port 1350
        sudo ip6tables -A OUTPUT -o bat0 -p udp --dport 1350 -j DROP
    fi
done
```
