#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)"

required=(
  "$ROOT/AGENTS.md"
  "$ROOT/rss/AGENTS.md"
  "$ROOT/agent/log.md"
  "$ROOT/agent/docs/context.md"
  "$ROOT/agent/docs/arch.md"
  "$ROOT/agent/docs/kb.md"
  "$ROOT/agent/docs/run.md"
  "$ROOT/agent/specs/000-roadmap.md"
  "$ROOT/docs/templates/code-template-standard.yaml"
  "$ROOT/docs/templates/web-template-standard.yaml"
  "$ROOT/docs/templates/template-standards.version"
  "$ROOT/docs/templates/README.md"
  "$SCRIPT_DIR/new-project.sh"
  "$SCRIPT_DIR/template-sync.sh"
  "$SCRIPT_DIR/template_sync.py"
  "$SCRIPT_DIR/onboarding-check.sh"
  "$SCRIPT_DIR/policy-check.sh"
  "$SCRIPT_DIR/parse_claude_chats.py"
  "$SCRIPT_DIR/run.sh"
  "$SCRIPT_DIR/build.sh"
)

missing=0
for path in "${required[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "[FAIL] missing: $path"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "monitor: FAIL (missing required artifacts)"
  exit 1
fi

last_log_line="$(grep -Ev '^\s*(#|$)' "$ROOT/agent/log.md" | tail -n 1 || true)"

echo "monitor: SUCCESS"
if [[ -n "$last_log_line" ]]; then
  echo "last-log: $last_log_line"
else
  echo "last-log: none"
fi
