# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A **Soldat Dedicated Server** deployment using Docker. The server binary is downloaded at image build time from the official Soldat download page — `docker compose build` is the only "build" step. All game configuration lives in `docker-compose.yml` as environment variables.

## Running the Server

```bash
# First-time setup
cp .env.example .env
# Edit .env and set ADMIN_PASSWORD at minimum

# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker compose logs -f
```

## Configuration

All `soldat.ini` and `server.ini` settings are passed as environment variables in [docker-compose.yml](docker-compose.yml):

- `SOLDAT_INI_<SECTION>_<Key>=<value>` — maps to a soldat.ini entry
- `SERVER_INI_<SECTION>_<Key>=<value>` — maps to a server.ini entry

Secrets (server name, passwords, greeting) are read from `.env` (gitignored). See [.env.example](.env.example) for the expected keys.

Startup parameters in env vars **override** any values the image would generate from its own defaults.

## Volumes

| Host path | Container path | Purpose |
| --------- | -------------- | ------- |
| `./mapslist.txt` | `/soldat/mapslist.txt` | Map rotation (read-only) |
| `./scripts/` | `/soldat/scripts/` | Custom Pascal scripts (read-only) |
| `soldat_logs` volume | `/soldat/logs/` | Runtime logs (persistent) |
| `soldat_anticheat` volume | `/soldat/anti-cheat/` | Ban data (persistent) |

## Adding Custom Scripts

Scripts use Pascal syntax. Place each script in its own subdirectory under `scripts/` with an `Includes.txt` manifest:

```text
scripts/
  MyScript/
    Includes.txt   ← lists the .pas files to load
    Core.pas
```

See [scripts/README.txt](scripts/README.txt) for full details. Scripting API reference: [devs.soldat.pl/wiki](http://devs.soldat.pl/wiki/index.php?title=Server_Scripting)

## Ports

| Port | Protocol | Purpose |
|------|---------|---------|
| 23073 | UDP | Game traffic |
| 23073 | TCP | Admin connections |
| 23083 | TCP | File transfers (game port + 10) |
