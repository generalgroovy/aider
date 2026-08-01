#!/usr/bin/env bash
set -Eeuo pipefail

for command_name in agent-doctor agent-project agent-run agent-status agent-stop agent-publish agent-clean; do
    rm -f "$HOME/.local/bin/$command_name"
done

printf 'Commands removed. Configuration and workspaces retained.\n'
