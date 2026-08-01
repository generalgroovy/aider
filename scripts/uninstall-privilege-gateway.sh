#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

rm -f /etc/sudoers.d/odysseus-agent
rm -f /usr/local/sbin/odysseus-admin
printf 'Gateway removed; agent account retained for review.\n'
