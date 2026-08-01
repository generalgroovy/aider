#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

agent_config_dir() { printf '%s\n' "${XDG_CONFIG_HOME:-$HOME/.config}/aider-agent"; }
agent_state_dir() { printf '%s\n' "${XDG_STATE_HOME:-$HOME/.local/state}/aider-agent"; }

agent_load_config() {
    local file
    file="$(agent_config_dir)/agent.env"
    if [[ -f "$file" ]]; then
        # shellcheck disable=SC1090
        source "$file"
    fi

    : "${ODYSSEUS_SERVICE:=odysseus}"
    : "${ODYSSEUS_URL:=http://127.0.0.1:7000}"
    : "${AGENT_WORKSPACE_ROOT:=$HOME/AgentWorkspaces}"
    : "${PROJECTS_ROOT:=$HOME/Projects}"
    : "${GITHUB_OWNER:=generalgroovy}"
    : "${AGENT_EXECUTOR_MODEL:=qwen2.5-coder:3b}"
    : "${AGENT_REVIEWER_MODEL:=qwen2.5-coder:7b}"
    : "${AGENT_UTILITY_MODEL:=qwen2.5-coder:1.5b}"
    : "${AGENT_TMUX_SESSION:=odysseus}"
    : "${AGENT_OPEN_BROWSER:=1}"
    : "${AGENT_UNLOAD_MODELS_ON_STOP:=1}"

    if [[ -z "${ODYSSEUS_DIR:-}" ]]; then
        if [[ -d "$HOME/odysseus" ]]; then
            ODYSSEUS_DIR="$HOME/odysseus"
        else
            ODYSSEUS_DIR="$HOME/Projects/odysseus"
        fi
    fi

    export ODYSSEUS_DIR ODYSSEUS_SERVICE ODYSSEUS_URL
    export AGENT_WORKSPACE_ROOT PROJECTS_ROOT GITHUB_OWNER
    export AGENT_EXECUTOR_MODEL AGENT_REVIEWER_MODEL AGENT_UTILITY_MODEL
    export AGENT_TMUX_SESSION AGENT_OPEN_BROWSER AGENT_UNLOAD_MODELS_ON_STOP
}

agent_die() { printf 'ERROR: %s\n' "$*" >&2; return 1; }
agent_log() { printf '\n==> %s\n' "$*"; }

agent_require() {
    local item
    for item in "$@"; do
        command -v "$item" >/dev/null 2>&1 || {
            agent_die "required command missing: $item"
            return 1
        }
    done
}

agent_overlay_file() { printf '%s\n' "$(agent_config_dir)/odysseus-workspaces.yml"; }

agent_compose() {
    local overlay
    overlay="$(agent_overlay_file)"
    [[ -f "$ODYSSEUS_DIR/docker-compose.yml" ]] || {
        agent_die "docker-compose.yml missing in $ODYSSEUS_DIR"
        return 1
    }
    [[ -f "$overlay" ]] || {
        agent_die "overlay missing: $overlay; run scripts/install.sh"
        return 1
    }
    (
        cd "$ODYSSEUS_DIR"
        docker compose -f docker-compose.yml -f "$overlay" "$@"
    )
}

agent_branch_allowed() { [[ "$1" == agent/odysseus-* ]]; }
agent_realpath() { realpath -m -- "$1"; }
