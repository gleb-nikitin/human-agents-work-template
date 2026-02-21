#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1" >&2
    exit 1
  }
}

require_cmd bash
require_cmd python3

sh_count=0
for sh_file in "$SCRIPT_DIR"/*.sh; do
  [[ -f "$sh_file" ]] || continue
  bash -n "$sh_file"
  sh_count=$((sh_count + 1))
done

py_files=(
  "$SCRIPT_DIR/parse_claude_chats.py"
  "$SCRIPT_DIR/template_sync.py"
)

for py_file in "${py_files[@]}"; do
  if [[ ! -f "$py_file" ]]; then
    echo "Error: missing required script: $py_file" >&2
    exit 1
  fi
  python3 -c 'import ast, pathlib, sys; p = pathlib.Path(sys.argv[1]); ast.parse(p.read_text(encoding="utf-8"), filename=str(p))' "$py_file"
done

echo "build-check: SUCCESS (shell_scripts=$sh_count, python=${#py_files[@]})"
