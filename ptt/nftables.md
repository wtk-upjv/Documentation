Author: @anto-nainFR

```bash
# WITH nftables
# Uncomment the following function if you want to use nftables instead of iptables
activate_ptt() {
    debug "Activation de PTT..."

    # Vérifie si la règle existe déjà
    if sudo nft list ruleset | grep -q 'udp dport 1350 drop'; then
        debug "La règle PTT existe déjà."
        return 0
    fi

    # Création de la table et chaîne si elles n'existent pas
    sudo nft add table ip6 ptt_table 2>/dev/null
    sudo nft add chain ip6 ptt_table output_chain '{ type filter hook output priority 0; }' 2>/dev/null

    # Ajout de la règle pour bloquer UDP port 1350 sortant via bat0
    sudo nft add rule ip6 ptt_table output_chain oifname "bat0" udp dport 1350 drop
    debug "Règle PTT ajoutée (nftables)."

    play -n synth 0.1 sine 2000 # Play a short beep sound to indicate activation
}
```

```bash
# WITH nftables
# Uncomment the following function if you want to use nftables instead of iptables
deactivate_ptt() {
    debug "Désactivation de PTT..."

    # Supprimer la règle si elle existe
    if sudo nft list ruleset | grep -q 'udp dport 1350 drop'; then
        sudo nft delete rule ip6 ptt_table output_chain handle $(sudo nft list chain ip6 ptt_table output_chain | grep 'udp dport 1350 drop' | awk '{print $NF}')
        debug "Règle PTT supprimée."
    else
        debug "Aucune règle PTT à supprimer."
    fi
    play -n synth 0.2 sine 1500 # Play a short beep sound to indicate deactivation
}
```