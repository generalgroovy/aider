#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mapfile -d '' files < <(
    find "$ROOT/bin" -type f -name 'agent-*' -print0
    find "$ROOT/scripts" "$ROOT/tests" -type f -name '*.sh' -print0
)

for file in "${files[@]}"; do
    printf 'bash -n %s\n' "${file#"$ROOT"/}"
    bash -n "$file"
done

if command -v shellcheck >/dev/null 2>&1; then
    shellcheck -x "${files[@]}"
else
    printf 'WARN: shellcheck unavailable; Bash syntax still validated.\n'
fi
