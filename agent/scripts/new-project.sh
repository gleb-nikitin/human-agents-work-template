#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)"
CODE_TEMPLATE="$ROOT/code/_project-template"
WEB_TEMPLATE="$ROOT/web/_project-template"
TEMPLATE_SYNC="$SCRIPT_DIR/template-sync.sh"

usage() {
  cat <<'EOF'
Usage:
  new-project.sh <code|web> <project-name> [options]

Options:
  --purpose "<text>"      Project purpose for agent/docs/arch.md
  --stack "<text>"        Stack summary for agent/docs/arch.md
  --boundaries "<text>"   Scope boundaries for agent/docs/arch.md
  --deployment "<text>"   Deployment model (web only; optional)
  --dry-run               Print actions without filesystem changes
  -h, --help              Show this help
EOF
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1" >&2
    exit 1
  }
}

require_path() {
  local p="$1"
  [[ -e "$p" ]] || {
    echo "Error: required path does not exist: $p" >&2
    exit 1
  }
}

is_kebab_case() {
  [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]
}

AREA="${1:-}"
NAME="${2:-}"
shift $(( $# >= 2 ? 2 : $# ))

PURPOSE="TBD"
STACK="TBD"
BOUNDARIES="TBD"
DEPLOYMENT="TBD"
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --purpose)
      PURPOSE="${2:-}"
      shift 2
      ;;
    --stack)
      STACK="${2:-}"
      shift 2
      ;;
    --boundaries)
      BOUNDARIES="${2:-}"
      shift 2
      ;;
    --deployment)
      DEPLOYMENT="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$AREA" || -z "$NAME" ]]; then
  usage
  exit 1
fi

if [[ "$AREA" != "code" && "$AREA" != "web" ]]; then
  echo "Error: area must be 'code' or 'web'" >&2
  exit 1
fi

if ! is_kebab_case "$NAME"; then
  echo "Error: project name must be kebab-case (example: billing-api)" >&2
  exit 1
fi

require_cmd cp
require_cmd date
require_cmd find
require_cmd python3
require_path "$ROOT"
require_path "$CODE_TEMPLATE"
require_path "$WEB_TEMPLATE"
require_path "$TEMPLATE_SYNC"

if [[ "$AREA" == "code" ]]; then
  TEMPLATE="$CODE_TEMPLATE"
else
  TEMPLATE="$WEB_TEMPLATE"
fi

if ! bash "$TEMPLATE_SYNC" --domain "$AREA" --dry-run >/dev/null 2>&1; then
  echo "Error: template standards for '$AREA' are not synchronized." >&2
  echo "Run: bash $TEMPLATE_SYNC --domain $AREA --apply" >&2
  exit 1
fi

DEST="$ROOT/$AREA/$NAME"
require_path "$ROOT/$AREA"

if [[ -e "$DEST" ]]; then
  echo "Error: destination already exists: $DEST" >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "[dry-run] copy template: $TEMPLATE -> $DEST"
  echo "[dry-run] append initial log entry to: $DEST/agent/log.md"
  echo "[dry-run] write initial architecture facts to: $DEST/agent/docs/arch.md"
  echo "[dry-run] ensure roadmap exists at: $DEST/agent/specs/000-roadmap.md"
  exit 0
fi

cp -R "$TEMPLATE" "$DEST"
# Remove macOS metadata files copied from template if present.
find "$DEST" -name '.DS_Store' -type f -delete

TS="$(date '+%Y-%m-%d %H:%M')"
printf '%s | initialized project from %s template | success\n' "$TS" "$AREA" >> "$DEST/agent/log.md"

if [[ "$AREA" == "web" ]]; then
  cat > "$DEST/agent/docs/arch.md" <<EOF
# Architecture

## Purpose
$PURPOSE

## Stack
$STACK

## Boundaries
$BOUNDARIES

## Deployment Model
$DEPLOYMENT
EOF
else
  cat > "$DEST/agent/docs/arch.md" <<EOF
# Architecture

## Purpose
$PURPOSE

## Stack
$STACK

## Boundaries
$BOUNDARIES
EOF
fi

echo "Created: $DEST"
