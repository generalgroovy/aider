#!/usr/bin/env bash
set -Eeuo pipefail

AGENT_USER="${AGENT_USER:-odysseus-agent}"
AGENT_GROUP="${AGENT_GROUP:-agentwork}"
CALLING_USER="${SUDO_USER:-$USER}"

if [[ "$(id -u)" -ne 0 ]]; then
    exec sudo --preserve-env=AGENT_USER,AGENT_GROUP "$0" "$@"
fi

id "$AGENT_USER" >/dev/null 2>&1 || useradd --create-home --shell /usr/bin/bash "$AGENT_USER"
passwd -l "$AGENT_USER"
getent group "$AGENT_GROUP" >/dev/null 2>&1 || groupadd "$AGENT_GROUP"
usermod -aG "$AGENT_GROUP" "$AGENT_USER"
id "$CALLING_USER" >/dev/null 2>&1 && usermod -aG "$AGENT_GROUP" "$CALLING_USER"

cat > /usr/local/sbin/odysseus-admin <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
action="${1:-}"
shift || true
logger -p authpriv.notice -t odysseus-admin -- \
  "sudo_user=${SUDO_USER:-unknown} action=$action args=$(printf '%q ' "$@")"

bounded_lines() {
    local count="${1:-150}"
    [[ "$count" =~ ^[0-9]+$ ]] || return 64
    ((count <= 1000)) || count=1000
    printf '%s\n' "$count"
}

case "$action" in
    ollama-status) exec /usr/bin/systemctl status ollama --no-pager ;;
    ollama-restart) exec /usr/bin/systemctl restart ollama ;;
    docker-status) exec /usr/bin/systemctl status docker --no-pager ;;
    docker-restart) exec /usr/bin/systemctl restart docker ;;
    journal-ollama)
        count="$(bounded_lines "${1:-150}")"
        exec /usr/bin/journalctl -u ollama -n "$count" --no-pager
        ;;
    journal-docker)
        count="$(bounded_lines "${1:-150}")"
        exec /usr/bin/journalctl -u docker -n "$count" --no-pager
        ;;
    *)
        printf 'Allowed: ollama-status, ollama-restart, docker-status, docker-restart, journal-ollama [n], journal-docker [n]\n' >&2
        exit 64
        ;;
esac
EOF

chown root:"$AGENT_GROUP" /usr/local/sbin/odysseus-admin
chmod 0750 /usr/local/sbin/odysseus-admin

cat > /etc/sudoers.d/odysseus-agent <<EOF
Defaults:${AGENT_USER} use_pty
Defaults:${AGENT_USER} logfile="/var/log/odysseus-agent-sudo.log"
Defaults:${AGENT_USER} log_input,log_output
${AGENT_USER} ALL=(root) NOPASSWD: /usr/local/sbin/odysseus-admin *
EOF
chmod 0440 /etc/sudoers.d/odysseus-agent
visudo -cf /etc/sudoers.d/odysseus-agent
bash -n /usr/local/sbin/odysseus-admin
printf 'Installed constrained gateway; no arbitrary root shell or package installation granted.\n'
