## Installation

<http://www.pogo.org.uk/~mark/trx/>  
<https://www.pogo.org.uk/~mark/trx/streaming-desktop-audio.html>

Install the `trx` package:

```bash
sudo apt install trx
```

## Info

`trx` package:

- Uses the opus codec and supports only 48000Hz sample rate.
- Listens one stream at a time (from one device)
- If the stream ends, it will listen to the next available (e.g. from another device).

- The RTP protocol (used by `trx`) controls the stream inside a single session:

  <https://en.wikipedia.org/wiki/Real-time_Transport_Protocol>  
  <https://datatracker.ietf.org/doc/html/rfc4571>

  - It keeps track of the packets order using the **Sequence Number**.
  - It plays audio at proper time with the **Timestamp**.
  - It uniquely identifies the source of a stream using the **Synchronization Source Identifier** (SSRC).

> TODO: Create a separate documentation if the paragraph gets bigger

## Debug

Use `tshark` to check if packets are sent:

```bash
sudo tshark -i wlp1s0 -f "host 239.0.0.1"
```

## Running

<http://www.pogo.org.uk/~mark/trx/streaming-desktop-audio.html>

Two devices:

- The sender device
- The receiver device

### Sender

Load the loopback device:

```bash
sudo modprobe snd-aloop
```

The default output device is now the loopback

> TODO: How to know which device is the default and change it?.

Add a plug device `wtkcap` (capture) in the file `~/.asoundrc`:

- The plug device converts the rate and format and make sure they are supported by `trx`.

```
pcm.wtkcap {
	type plug
	slave {
		pcm "hw:Loopback,1,0"
		rate 48000
		format S16_LE
	}
}
```

Play audio to the loopback:

```bash
aplay --device=hw:Loopback,0,0 Blues_pour_le_chat_48000.wav
```

> TODO: Add a plug device for playback?):

Stream audio from the loopback using `trx-tx`:

- `-d wtkcap` to use the plug capture device.
- `-h 239.0.0.1` to stream to multicast address

```bash
sudo -E trx-tx -d wtkcap -h 239.0.0.1
```

### Receiver

Play audio to the default device using `trx-rx`:

- `-m 32` to add extra buffer time (default 16ms)

```bash
sudo -E trx-rx  -m 32 -h 239.0.0.1
```
