### Choix de TTS pour le Projet - PicoTTS ou Coqui TTS

**PicoTTS** fonctionne localement sur Raspberry Pi et peut générer rapidement des messages vocaux sans dépendance externe.

Pour des voix plus naturelles ou dynamiques, Coqui TTS peut être utilisé sur une machine avec GPU pour générer les fichiers audio, qui seront ensuite transférés vers les Raspberry Pi.

On réalise le choix d'utiliser PicoTTS, car il est moins exigeant en ressources et plus simple à utiliser. La qualité reste correcte, et nous ne souhaitons pas mélanger différents outils TTS.

---
### COMPARATIF DES OUTILS TTS EN BASH

| Outil             | Naturel    | Langue fr   | Installation facile  | Ligne de commande   | Offline | Remarques                                             |
| ----------------- | ---------- | ----------- | -------------------- | ------------------- | ------- | ----------------------------------------------------- |
| **Coqui TTS**     | 🟢🟢🟢 | ✅ Oui       | ⚠️ Moyennement       | ✅ Oui               | ✅ Oui   | Meilleure qualité, voix neuronales, usage Python/Bash |
| **Pico TTS**      | 🟢     | ✅ Oui       | ✅ Très facile        | ✅ Oui (`pico2wave`) | ✅ Oui   | Légère, fluide, voix agréable                         |
| **Festival**      | 🟠       | ✅ Oui*      | ⚠️ Moyen             | ✅ Oui               | ✅ Oui   | Très robotique sans voix premium                      |
| **eSpeak NG**     | 🔴       | ✅ Oui       | ✅ Facile             | ✅ Oui               | ✅ Oui   | Très robotique, utile pour scripts rapides            |
| **Google TTS**    | 🟢🟢🟢 | ✅ Excellent | ❌ Nécessite Internet | ✅ Oui (curl)        | ❌ Non   | Qualité Google, pas local                             |
| **gTTS (Python)** | 🟢🟢   | ✅ Oui       | ✅ Facile (via pip)   | ✅ Via script        | ❌ Non   | Utilise Google API en ligne                           |

---

## 1. **Coqui TTS** (Meilleure qualité, voix neuronales)

### Avantages :
- Voix très naturelles (neural TTS)
- Fonctionne offline
- Supporte le français
- Très flexible (voix personnalisées)

### Installation (via `pip`) :

```bash
pip install TTS
```

### Exemple Bash :

```bash
tts --text "Bonjour, comment ça va ?" --model_name "tts_models/fr/mai/tacotron2-DDC" --out_path output.wav
aplay output.wav
```

> 📦 Coqui permet d’utiliser des modèles français très réalistes. Peut être utilisé via Bash avec des commandes simples.

---

## 2. **Pico TTS (pico2wave)** – Facile, fluide, local

### Avantages :
- Très léger et rapide
- Voix française fluide (mais pas neural)
- Facile à installer et utiliser

### Installation :
```bash
sudo apt install libttspico-utils
```

### Exemple :
```bash
pico2wave -l fr-FR -w test.wav "Bonjour, je suis Pico TTS"; 
aplay test.wav
```

---

## 3. **Festival TTS**
### Avantages :
- Scriptable
- 100% local

### Inconvénients :
- Voix françaises robotisées
- Voix fr à installer manuellement

---

## Résumé clair pour ton usage

| Objectif                       | Outil recommandé              |
| ------------------------------ | ----------------------------- |
| 🌟 Qualité vocale naturelle    | **Coqui TTS**                 |
| ⚡ Léger, rapide et fluide      | **Pico TTS**                  |
| 🧠 Script Bash + Customisation | **Festival** ou **eSpeak NG** |
| 🌐 Utilisation web             | **Google TTS / gTTS**         |
