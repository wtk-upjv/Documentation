## Systemd service tty

Disable `tty1`:

```bash
sudo systemctl disable getty@tty1.service
sudo systemctl stop getty@tty1.service
```

Enable the service with a dedicated tty:

- `TTYReset` Reset the terminal via both ioctl()s and via ANSI sequences.

<https://github.com/systemd/systemd/blob/main/src/basic/terminal-util.c#L1873>

- `TTYVHangup` Disconnect all the clients which have opened the terminal device. Send SIGHUP to the processes.

- `TTYVDisallocate` Deallocate the VT, clear the screen and clear the scrolling buffer.

<https://github.com/systemd/systemd/blob/main/src/basic/terminal-util.c#L833>

```ini
[Unit]
Description=Volume control script on tty1
After=multi-user.target

[Service]
ExecStart=/home/isri/test.sh
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
Restart=always
User=isri

[Install]
WantedBy=multi-user.target
```