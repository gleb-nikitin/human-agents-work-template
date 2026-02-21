#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)"

if [[ ! -f "$SCRIPT_DIR/template_sync.py" ]]; then
  echo "Error: missing helper script: $SCRIPT_DIR/template_sync.py" >&2
  exit 1
fi

exec python3 "$SCRIPT_DIR/template_sync.py" --root "$ROOT" "$@"
