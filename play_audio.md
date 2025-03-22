## Installing the audio server

Sources:

- [PipeWire Debian12 wiki](https://wiki.debian.org/PipeWire#Debian_12)

Install the packages `pipewire`, `wireplumber` and `pipewire-pulse`:

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

## Playing audio

### mpg123

<https://mpg123.org/index.shtml>

Install `mpg123` and play an MP3 file:

```bash
sudo apt install mpg123
mpg123 Blues_pour_le_chat.mp3
```

### vorbis-tools

Install `vorbis-tools` and play an Ogg file:

```bash
sudo apt install vorbis-tools
ogg123 Blues_pour_le_chat.ogg
```

Note: its lagging comparing to `mpg123`
