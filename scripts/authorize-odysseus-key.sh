#!/usr/bin/env bash
set -Eeuo pipefail

AGENT_USER="${AGENT_USER:-odysseus-agent}"
PUBLIC_KEY_FILE="${1:-}"
[[ -n "$PUBLIC_KEY_FILE" ]] || {
    printf 'Usage: %s PUBLIC_KEY_FILE\n' "$0" >&2
    exit 64
}
PUBLIC_KEY_FILE="$(realpath "$PUBLIC_KEY_FILE")"
[[ -f "$PUBLIC_KEY_FILE" ]] || {
    printf 'Missing key: %s\n' "$PUBLIC_KEY_FILE" >&2
    exit 1
}

if [[ "$(id -u)" -ne 0 ]]; then
    exec sudo --preserve-env=AGENT_USER "$0" "$PUBLIC_KEY_FILE"
fi

id "$AGENT_USER" >/dev/null 2>&1 || {
    printf 'Missing account: %s\n' "$AGENT_USER" >&2
    exit 1
}

home_dir="$(getent passwd "$AGENT_USER" | cut -d: -f6)"
install -d -m 0700 -o "$AGENT_USER" -g "$AGENT_USER" "$home_dir/.ssh"
public_key="$(tr -d '\r\n' < "$PUBLIC_KEY_FILE")"
[[ "$public_key" == ssh-* ]] || {
    printf 'Not an OpenSSH public key.\n' >&2
    exit 1
}

entry="from=\"127.0.0.1,172.16.0.0/12\",no-agent-forwarding,no-port-forwarding,no-X11-forwarding $public_key"
authorized_keys="$home_dir/.ssh/authorized_keys"
touch "$authorized_keys"
grep -Fqx "$entry" "$authorized_keys" || printf '%s\n' "$entry" >> "$authorized_keys"
chown "$AGENT_USER:$AGENT_USER" "$authorized_keys"
chmod 0600 "$authorized_keys"
printf 'Restricted key authorized for %s.\n' "$AGENT_USER"
