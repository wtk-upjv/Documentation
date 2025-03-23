# Playing audio (local)

## Installing the audio server (PulseAudio)

Sources:

- [PipeWire Debian12 wiki](https://wiki.debian.org/PipeWire#Debian_12)

Install the packages `pipewire`, `wireplumber` and `pipewire-pulse` (`wireplumber` and `pipewire-pulse` are recommended packages installed with `pipewire`):

```bash
apt install pipewire
```

Enable the session manager and reboot:

```bash
systemctl --user --now enable wireplumber.service
sudo systemctl reboot now
```

Check the service logs:

```bash
journalctl --user --unit wireplumber
```

Install the PulseAudio utilities:

```bash
sudo apt install pulseaudio-utils
```

Check if the PulseAudio server is working properly:

```bash
LANG=C pactl info | grep '^Server Name'
```
```text
Server Name: PulseAudio (on PipeWire 1.2.7)
```

## Installing the ALSA plugin


Install the ALSA plugin for PipeWire (`trx` uses ALSA):

```bash
apt install pipewire-alsa
```

Check if it is correctly installed:

```bash
LANG=C aplay -L | grep -A 1 default
```
```text
default
    Default ALSA Output (currently PipeWire Media Server)
--
sysdefault:CARD=Headphones
    bcm2835 Headphones, bcm2835 Headphones
--
sysdefault:CARD=vc4hdmi
    vc4-hdmi, MAI PCM i2s-hifi-0
```

## Playing audio

### mpg123

<https://mpg123.org/index.shtml>

Install `mpg123` and play an MP3 file:

```bash
sudo apt install mpg123

# Default output device is pulse
mpg123 --output pulse Blues_pour_le_chat.mp3

# Play on output device alsa
mpg123 --output alsa Blues_pour_le_chat.mp3
```

### vorbis-tools

Install `vorbis-tools` and play an Ogg file:

```bash
sudo apt install vorbis-tools

# Default output device is alsa
ogg123 --device alsa Blues_pour_le_chat.ogg
```

Note: its lagging comparing to `mpg123`
