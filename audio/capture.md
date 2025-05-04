# How to use the capture device

## Rasberry Pi 3



## Default device

- P<https://superuser.com/questions/626606/how-to-make-alsa-pick-a-preferred-sound-device-automatically#630048>
- Alsa sound doc: <https://www.kernel.org/doc/html/v6.14-rc2/sound/alsa-configuration.html>

List the cards:

```bash
cat /proc/asound/cards
```

List the kernel modules:

```bash
cat /proc/asound/modules
```

### Config

?

### Environment variables

Use environment variables to select the default device:

```bash
export ALSA_CARD=Device
aplay toto.wav
```

### Modules

Reserve the first slot for the first connected usb sound card:

```bash
# /etc/modprobe.d/wtk-alsa.conf
options snd slots=snd-usb-audio
```

## Save and play your capture

```bash
# Record
arecord --format=dat --device="default:CARD=Device" --duration 5 /tmp/test-mic.wav

# Play
aplay --device="default:CARD=Device" /tmp/test-mic.wav
```

## Stream the capture device with `trx-tx`

Select your capture device and run:

```bash
# Find your device
arecord --list-pcms

# Stream your device
sudo -E trx-tx  -v 1 -d default:CARD=Device -h 239.0.0.1
```
