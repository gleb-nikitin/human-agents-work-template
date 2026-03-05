#!/usr/bin/env bash
set -euo pipefail

# Template sync: compare projects against the unified template.
# Usage:
#   bash agent/scripts/template-sync.sh --dry-run
#   bash agent/scripts/template-sync.sh --apply
#   bash agent/scripts/template-sync.sh --domain code --dry-run
#   bash agent/scripts/template-sync.sh --domain web --apply

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec python3 "$SCRIPT_DIR/template_sync.py" "$@"
