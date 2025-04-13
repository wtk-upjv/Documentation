## Installation

<http://www.pogo.org.uk/~mark/trx/>

Downloading and extracting:

```bash
curl --location --remote-name http://www.pogo.org.uk/~mark/trx/releases/trx-0.5.tar.gz
tar --extract --file trx-0.5.tar.gz --auto-compress
```

Install dependencies:

- `libasound2-dev`
- `libopus-dev`
- `libortp-dev`

```bash
sudo apt install libasound2-dev libopus-dev libortp-dev
```

Add the missing dynamic dependency `libctoolbox.so`:

```makefile
# Makefile - line 14
LDLIBS_ORTP ?= -lortp -lbctoolbox
```

Compile and install the program:

```bash
make
sudo make install
```

## Running

Get an error and I don't know how to get this thing working:

```bash
tx -h 239.0.0.1
```
```text
trx (C) Copyright 2020 Mark Hills <mark@xwax.org>
sched_setscheduler: Operation not permitted

```

Check [`trx` package](./trx_package.md)
