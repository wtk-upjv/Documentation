Author: @anto-nainFR

# Description
Enable support for connecting a Bluetooth audio device (e.g., headset with integrated microphone) to a Raspberry Pi running Linux. The goal is to allow the Raspberry Pi to use the Bluetooth device both as an audio output (speaker/headset) and as an audio input (microphone) using [BlueALSA](https://github.com/Arkq/bluez-alsa)

# Setup Instructions
1. Install Required Packages
```bash
sudo apt update
sudo apt install bluealsa bluez pulseaudio-utils alsa-utils
```

2. Enable and Start Bluetooth Services
```bash
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```

4. Pair and Trust the Bluetooth Device

```bash
bluetoothctl
# In interactive mode:
power on
agent on
scan on
# wait to see your device MAC address, then:
pair XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
exit
```
6. Start BlueALSA
```bash
sudo systemctl enable bluealsa
sudo systemctl start bluealsa
```
8. Test Playback (Headphones)
```bash
aplay -D bluealsa some-audio.wav
```
10. Test Microphone (Recording)
```bash
arecord -D bluealsa test.wav
```