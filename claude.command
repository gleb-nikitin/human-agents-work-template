#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" >/dev/null 2>&1 && pwd)"
WORK_DIR="$SCRIPT_DIR"
CHATS_DIR="$WORK_DIR/human-docs/claude-chats"
CLAUDE_BIN="${CLAUDE_BIN:-$HOME/.local/bin/claude}"
SESSION_KEY="$(printf '%s' "$WORK_DIR" | sed 's#/#-#g')"
SESSIONS_DIR="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/projects/$SESSION_KEY}"

mkdir -p "$CHATS_DIR"

# Determine next chat number
last=$(ls "$CHATS_DIR" 2>/dev/null | grep -E '^[0-9]+\.md$' | sed 's/\.md$//' | sort -n | tail -1 || true)
next=$(( ${last:-0} + 1 ))
FINAL_LOG="$CHATS_DIR/$next.md"

START_MARKER=$(mktemp)
trap 'rm -f "$START_MARKER"' EXIT

cd "$WORK_DIR"
"$CLAUDE_BIN" || true

SESSION_FILE=""
if [[ -d "$SESSIONS_DIR" ]]; then
  SESSION_FILE=$(find "$SESSIONS_DIR" -name '*.jsonl' -newer "$START_MARKER" -print 2>/dev/null | head -n 1 || true)
  if [[ -z "$SESSION_FILE" ]]; then
    SESSION_FILE=$(ls -t "$SESSIONS_DIR"/*.jsonl 2>/dev/null | head -n 1 || true)
  fi
fi

if [[ -z "$SESSION_FILE" ]]; then
  echo "No session file found, log not saved."
  exit 0
fi

python3 - "$SESSION_FILE" > "$FINAL_LOG" <<'PYEOF'
import sys, json

path = sys.argv[1]
messages = []

with open(path) as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            entry = json.loads(line)
        except Exception:
            continue

        msg = entry.get('message', {})
        role = msg.get('role') if isinstance(msg, dict) else None
        content = msg.get('content', '') if isinstance(msg, dict) else ''

        if role == 'user' and isinstance(content, str) and content.strip():
            messages.append(f"**Human:** {content.strip()}")

        elif role == 'assistant' and isinstance(content, list):
            parts = [c['text'] for c in content if isinstance(c, dict) and c.get('type') == 'text']
            text = ''.join(parts).strip()
            if text:
                messages.append(f"**Assistant:** {text}")

print('\n\n---\n\n'.join(messages))
PYEOF

echo "Chat saved: $FINAL_LOG"
