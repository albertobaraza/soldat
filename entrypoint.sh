#!/usr/bin/env bash
set -euo pipefail

# Writes one INI section block per unique section found in matching env vars.
# Usage: generate_ini SOLDAT_INI /soldat/soldat.ini
generate_ini() {
  local prefix="$1"
  local output="$2"
  local current_section=""

  > "$output"
  while IFS= read -r line; do
    var="${line%%=*}"
    value="${line#*=}"
    rest="${var#${prefix}_}"
    section="${rest%%_*}"
    key="${rest#${section}_}"

    if [ "$section" != "$current_section" ]; then
      [ -n "$current_section" ] && printf '\n' >> "$output"
      printf '[%s]\n' "$section" >> "$output"
      current_section="$section"
    fi
    printf '%s=%s\n' "$key" "$value" >> "$output"
  done < <(env | grep "^${prefix}_" | sort)
}

mkdir -p /soldat/logs /soldat/anti-cheat

generate_ini "SOLDAT_INI" /soldat/soldat.ini

# server.ini is used as-is from the bundled assets; generating it from env vars
# causes a version mismatch that corrupts the log path configuration and crashes the server.
touch /soldat/banned.txt /soldat/bannedhw.txt

cd /soldat
exec ./soldatserver
