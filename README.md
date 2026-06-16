# Soldat Dedicated Server

A Docker-based [Soldat](https://soldat.pl) dedicated server. The game binary is downloaded automatically at build time — no manual asset management needed.

## Requirements

- [Docker](https://docs.docker.com/get-docker/) with the Compose plugin

## Quick start

```bash
# 1. Copy the example env file and set your admin password
cp .env.example .env
$EDITOR .env

# 2. Build the image (downloads the server binary)
docker compose build

# 3. Start the server
docker compose up -d
```

The server will be reachable on **UDP/TCP 23073** (game) and **TCP 23083** (file transfers).

## Configuration

All settings are passed as environment variables in [docker-compose.yml](docker-compose.yml). There is no config file to edit manually.

| Variable pattern | Maps to |
|---|---|
| `SOLDAT_INI_<SECTION>_<Key>` | `soldat.ini` |

**Example:**
```yaml
SOLDAT_INI_GAME_GameStyle: "3"       # CTF
SOLDAT_INI_NETWORK_Max_Players: "16"
```

### Secrets

Sensitive values are read from `.env` (gitignored). Copy [.env.example](.env.example) to get started:

| Variable | Description |
|---|---|
| `ADMIN_PASSWORD` | Admin console password (**required**) |
| `SERVER_NAME` | Public server name |
| `GAME_PASSWORD` | Password to join (leave blank for public) |
| `GREETING` | Message shown to players on connect |

### Game modes

Set `SOLDAT_INI_GAME_GameStyle` to one of:

| Value | Mode |
|---|---|
| `0` | Deathmatch |
| `1` | Pointmatch |
| `2` | Teammatch |
| `3` | Capture the Flag (default) |
| `4` | Rambomatch |
| `5` | Infiltration |
| `6` | Hold the Flag |

## Map rotation

Edit [mapslist.txt](mapslist.txt) — one map name per line, no extension:

```
ctf_Ash
ctf_Blade
ctf_Voland
```

The file is mounted read-only into the container, so changes take effect on the next server restart.

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 23073 | UDP | Game traffic |
| 23073 | TCP | Admin console |
| 23083 | TCP | File transfers |

## Persistent data

| Volume | Container path | Contents |
|---|---|---|
| `soldat_logs` | `/soldat/logs/` | Server logs |
| `soldat_anticheat` | `/soldat/anti-cheat/` | Ban lists |

## Useful commands

```bash
# View live logs
docker compose logs -f

# Stop the server
docker compose down

# Rebuild after a configuration change
docker compose up -d --build

# Open admin console (replace PASSWORD with your ADMIN_PASSWORD)
nc localhost 23073
```
