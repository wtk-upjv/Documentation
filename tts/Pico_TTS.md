Author: @Senku89

## Pour installer PicoTTS

Cela installe l’outil `pico2wave`, qui permet de convertir du texte en audio (fichier `.wav`).
```bash
sudo apt install libttspico-utils
```

## Script bash picoTTS.sh

Ce script permet de faire de la synthèse vocale directement depuis le terminal.
Il utilise 3 **paramètres** (tous en ligne de commande):
- Texte à lire (**obligatoire**) : C’est la phrase que PicoTTS doit convertir en voix.
- Exemple : `"Bonjour le monde"`
- Langue (**optionnel**, défaut : `fr-FR`) : Langue de la synthèse vocale.
- Exemples : `fr-FR`, `en-US`, `en-GB`, `es-ES`, `de-DE`, `it-IT`
- Périphérique audio ALSA (**optionnel**, par défaut : `default`) : Utilisé pour spécifier la sortie audio si besoin.
- Exemple : `plughw:1,0` (USB), `plughw:0,0` (jack), etc.
- On peux voir les périphériques disponibles avec `aplay -l`

```bash
#!/bin/bash

# Fonction TTS avec PicoTTS
speak() {
    local TEXT="$1"
    local LANG="${2:-fr-FR}"         # Langue par defaut : francais
    local AUDIO_DEV="${3:-default}"  # Peripherique audio par defaut
    local TMPFILE=$(mktemp --suffix=.wav)

    # Generation de la voix
    pico2wave -l="$LANG" -w="$TMPFILE" "$TEXT"

    # Lecture audio
    aplay -D "$AUDIO_DEV" "$TMPFILE"

    # Nettoyage
    rm -f "$TMPFILE"
}

main() {
    if [ $# -lt 1 ]; then
        echo "Utilisation : $0 \"Texte a dire\" [langue] [peripherique]"
        echo "Exemple     : $0 \"Bonjour le monde\" fr-FR plughw:1,0"
        exit 1
    fi

    TEXT="$1"
    LANG="${2:-fr-FR}"
    AUDIO_DEV="${3:-default}"

    speak "$TEXT" "$LANG" "$AUDIO_DEV"
}

main "$@"
```