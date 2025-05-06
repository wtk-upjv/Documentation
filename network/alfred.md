# Alfred

- Alfred README: <https://git.open-mesh.org/alfred.git/tree/README.rst>
- Alfred architecture: <https://www.open-mesh.org/projects/alfred/wiki/Alfred_architecture>

## Server

Launch a server and open the unix socket `/var/run/alfred.sock`

```bash
sudo alfred --interface bat0 --primary --update-command ./toto.sh
```

Launch a script at each update:

```bash
sudo alfred --interface bat0 --primary --update-command ./toto.sh
```

## Client

Set data:

```bash
echo toto | sudo alfred -s 65
```

Retrieve data:

```bash
sudo alfred -r 65
```

Result:

```text
{ "aa:a5:50:ee:0c:0b", "toto\x0a" },
```
