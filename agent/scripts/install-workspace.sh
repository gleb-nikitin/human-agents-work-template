#!/usr/bin/env bash
set -euo pipefail

# Install workspace: replace __ROOT__ placeholder with the real install path.
# Usage: bash agent/scripts/install-workspace.sh /absolute/workspace/root

if [ $# -lt 1 ]; then
  echo "Usage: $0 /absolute/workspace/root"
  exit 1
fi

TARGET="$1"

if [[ "$TARGET" != /* ]]; then
  echo "Error: path must be absolute (start with /)"
  exit 1
fi

# Remove trailing slash
TARGET="${TARGET%/}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Workspace root: $WORKSPACE_ROOT"
echo "Install target: $TARGET"

# Check for rg (ripgrep)
if ! command -v rg &>/dev/null; then
  echo "Error: rg (ripgrep) is required but not found."
  exit 1
fi

# Count replacements
COUNT=$(rg --count-matches '__ROOT__' "$WORKSPACE_ROOT" --type-add 'docs:*.{md,yaml,yml,sh,py,json,toml}' --type docs 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')
echo "Found $COUNT occurrences of __ROOT__ to replace."

if [ "$COUNT" -eq 0 ]; then
  echo "Nothing to replace. Workspace may already be installed."
  exit 0
fi

# Replace placeholder
rg -l '__ROOT__' "$WORKSPACE_ROOT" --type-add 'docs:*.{md,yaml,yml,sh,py,json,toml}' --type docs 2>/dev/null | while read -r file; do
  sed -i '' "s|__ROOT__|${TARGET}|g" "$file"
  echo "  replaced in: $file"
done

echo ""
echo "Replacement complete."

# Audit for personal markers
echo ""
echo "Auditing for personal markers..."
PERSONAL_MARKERS=("glebnikitin" "/Users/glebnikitin")
FOUND_PERSONAL=0
for marker in "${PERSONAL_MARKERS[@]}"; do
  HITS=$(rg -c "$marker" "$WORKSPACE_ROOT" 2>/dev/null | head -5)
  if [ -n "$HITS" ]; then
    echo "  WARNING: found '$marker' in:"
    echo "$HITS" | sed 's/^/    /'
    FOUND_PERSONAL=1
  fi
done

if [ "$FOUND_PERSONAL" -eq 0 ]; then
  echo "  No personal markers found. Clean."
fi

echo ""
echo "Install complete. Review rss/AGENTS.md for shared policy."
