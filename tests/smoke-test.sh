#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for file in "$ROOT"/bin/agent-*; do
    AIDER_AGENT_LIB_DIR="$ROOT/scripts" bash "$file" --help >/dev/null
done

temporary_home="$(mktemp -d)"
trap 'rm -rf "$temporary_home"' EXIT
HOME="$temporary_home" \
XDG_CONFIG_HOME="$temporary_home/.config" \
XDG_STATE_HOME="$temporary_home/.local/state" \
bash "$ROOT/scripts/install.sh" >/dev/null

for command_name in agent-doctor agent-project agent-run agent-status agent-stop agent-publish agent-clean; do
    test -x "$temporary_home/.local/bin/$command_name"
done

test -f "$temporary_home/.config/aider-agent/agent.env"
test -f "$temporary_home/.config/aider-agent/odysseus-workspaces.yml"
printf 'Smoke tests passed.\n'
