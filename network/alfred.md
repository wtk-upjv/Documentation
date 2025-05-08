# Alfred

- Alfred README: <https://git.open-mesh.org/alfred.git/tree/README.rst>
- Alfred architecture: <https://www.open-mesh.org/projects/alfred/wiki/Alfred_architecture>

## Summary

Provide a distributed hash table:

- Must be recompiled to change internal values (data timeout).
- Can run a script each time the data in the table change (added, updated or suppressed).
- For each data-type, the dataset is [ { source_MAC_address: data }, ... ].
- Only source MAC address. We must translate to IP multicast address.

## Server

Run a primary server and open the unix socket `/var/run/alfred.sock`

```bash
sudo alfred --interface bat0 --primary
```

Run a primary server:

- Run a script at each non-local data update.
- Synchronise with the other primary servers each second.

```bash
sudo alfred --interface bat0 --primary --update-command ./toto.sh --sync-period 1
```

### Timeout

The timeout is by default 10min:

- You must recompile the program to change the value.
- **Timeout is from the last time the information is received / refreshed.**

Three types of data source:

- Data source goes from 0 to 1 and 2 each time the data type is passed to another server.
- Only SOURCE_LOCAL and SOURCE_FIRST_HAND are synchronised to other primary servers (no loop).

```
enum data_source {
	SOURCE_LOCAL = 0,
	SOURCE_FIRST_HAND = 1,
	SOURCE_SYNCED = 2,
};
```

Example with `--sync-period 1` and `ALFRED_DATA_TIMEOUT 10`:

| Time | Action | data-type | data-source | update |
| - | - | - | - | - |
| 0s  | srv1 learn from local client | 100 | SOURCE_LOCAL | no  |
| 1s  | srv2 learn from srv1   | 100 | SOURCE_FIRST_HAND | yes |
| 10s | srv1 forget | 100 || yes |
| 11s | srv1 learn from srv2 | 100 | SOURCE_FIRST_SYNCED | yes |
| 20s | srv2 forget | 100 || yes |
| 30s | srv1 forget | 100 || yes |

So `srv1` will run **three times** the update command.

## Client

Set data:

```bash
echo toto | sudo alfred --set-data 65
```

Retrieve data:

```bash
sudo alfred --request 65
```
```text
{ "aa:a5:50:ee:0c:0b", "toto\x0a" },
```

Listen events from the server:

- Each time the data is updated (local client or synchronised).
- No event when the data timed out.

```bash
sudo alfred --event-monitor
```
```text
Event: type = 100, source = a6:f5:33:db:82:91
Event: type = 100, source = a6:f5:33:db:82:91
```
