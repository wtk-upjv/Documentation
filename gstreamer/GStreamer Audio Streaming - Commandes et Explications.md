_Document concis pour une mise en place simple d’un streaming audio RTP Opus avec GStreamer en local._

## 1) Commande de Réception (Reception)

```bash
gst-launch-1.0 -v \
  udpsrc port=5000 caps="application/x-rtp, media=audio, encoding-name=OPUS, payload=97, clock-rate=48000, channels=1, ssrc=1356955624" \
  ! rtpopusdepay \
  ! opusdec \
  ! audioconvert ! audioresample ! alsasink
```

### Description rapide :

- **udpsrc** : écoute UDP sur le port 5000, avec des paquets RTP Opus mono 48kHz.
- **rtpopusdepay** : extraction du flux Opus depuis RTP.
- **opusdec** : décodage Opus → audio PCM.
- **audioconvert + audioresample** : adaptation du format et fréquence.
- **alsasink** : lecture sur la sortie audio ALSA.

---

## 2) Commande d’Émission (Transmission)

```bash
gst-launch-1.0 -v \
  alsasrc ! audioconvert ! audioresample ! audio/x-raw,channels=1,rate=48000 \
  ! opusenc \
  ! rtpopuspay pt=97 ssrc=1356955624 \
  ! udpsink host=127.0.0.1 port=5000
```

### Description rapide :

- **alsasrc** : capture micro via ALSA.
- **audioconvert + audioresample** : formatage audio en mono 48kHz.
- **opusenc** : encodage audio en Opus.
- **rtpopuspay** : encapsulation RTP avec payload 97, SSRC fixe.
- **udpsink** : envoi UDP vers `127.0.0.1:5000`.

---

## 3) Résumé du Flux Audio

|Étape|Émetteur|Récepteur|
|---|---|---|
|Capture audio|Micro (ALSA)|-|
|Formatage|Convert + Resample|-|
|Encodage|Opus|Décodage Opus|
|Paquet RTP|RTP Opus + payload=97 + ssrc|Extraction RTP|
|Transmission|UDP → localhost:5000|UDP écoute port 5000|
|Lecture audio|-|ALSA (carte son)|

---

## 4) Test Local Simple (sans réseau)

```bash
gst-launch-1.0 -v \
  alsasrc device=hw:1,0 ! audio/x-raw,format=S16LE,channels=1,rate=48000 ! audioconvert ! audioresample ! autoaudiosink
```

Ou avec plughw :

```bash
gst-launch-1.0 -v \
  alsasrc device=plughw:1,0 ! audio/x-raw,format=S16LE,channels=1,rate=48000 ! audioconvert ! audioresample ! autoaudiosink
```

---

- **Note**:
	- `payload=97` et `ssrc=1356955624` doivent correspondre entre émetteur et récepteur.
	- Utilisation de la fréquence en 48kHz et audio en mono (1 canal)