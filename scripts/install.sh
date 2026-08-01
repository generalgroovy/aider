#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/aider-agent"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/aider-agent"
BIN="$HOME/.local/bin"

install -d -m 0755 "$BIN"
install -d -m 0700 "$CONFIG" "$STATE" "$HOME/AgentWorkspaces"

for file in "$ROOT"/bin/agent-*; do
    install -m 0755 "$file" "$BIN/$(basename "$file")"
done
install -m 0644 "$ROOT/scripts/lib.sh" "$CONFIG/lib.sh"
install -m 0644 "$ROOT/compose/odysseus-workspaces.yml" "$CONFIG/odysseus-workspaces.yml"
[[ -f "$CONFIG/agent.env" ]] ||
    install -m 0600 "$ROOT/config/agent.env.example" "$CONFIG/agent.env"

if command -v fish >/dev/null 2>&1; then
    fish -c "fish_add_path '$BIN'" || true
fi

printf 'Installed commands in %s\nConfiguration: %s/agent.env\n' "$BIN" "$CONFIG"
printf 'Next: exec fish; agent-doctor\n'
