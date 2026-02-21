#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)"
CODE_ROOT="$ROOT/code"
WEB_ROOT="$ROOT/web"
TEMPLATE_SYNC="$SCRIPT_DIR/template-sync.sh"
LOG_LINE_REGEX='^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}\ \|\ .+\ \|\ .+$'

FAILED=0
CHECKED=0

# ---------- helpers ----------
print_fail() {
  local project="$1"
  local message="$2"
  FAILED=$((FAILED + 1))
  echo "[FAIL] $project :: $message"
}

print_ok() {
  local project="$1"
  local message="$2"
  echo "[OK]   $project :: $message"
}

is_kebab_case() {
  [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]
}

require_file() {
  local project="$1"
  local file="$2"
  if [[ ! -f "$file" ]]; then
    print_fail "$project" "missing file: $file"
  fi
}

require_any_file() {
  local project="$1"
  local label="$2"
  shift 2

  local file
  for file in "$@"; do
    if [[ -f "$file" ]]; then
      return
    fi
  done

  print_fail "$project" "missing file ($label): expected one of: $*"
}

check_agents_logging_timestamp_rule() {
  local project="$1"
  local agents_file="$2"

  if [[ ! -f "$agents_file" ]]; then
    print_fail "$project" "missing file: $agents_file"
    return
  fi

  # Lightweight enforcement only: require explicit anti-backfill logging rule text in project AGENTS.
  if ! grep -Eqi 'current write-time timestamps only|no backfilled/retroactive timestamps|no backfill|Logging Timestamp Rule' "$agents_file"; then
    print_fail "$project" "AGENTS missing logging timestamp rule (no-backfill/current write-time)"
  fi
}

check_log_file() {
  local project="$1"
  local log_file="$2"

  if [[ ! -f "$log_file" ]]; then
    print_fail "$project" "missing file: $log_file"
    return
  fi

  local has_entry=0
  local lineno=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    lineno=$((lineno + 1))
    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^# ]] && continue
    if [[ "$line" =~ $LOG_LINE_REGEX ]]; then
      has_entry=1
    else
      print_fail "$project" "invalid log format at line $lineno in $log_file"
    fi
  done < "$log_file"

  if [[ "$has_entry" -eq 0 ]]; then
    print_fail "$project" "log has no factual entries: $log_file"
  fi
}

check_legacy_agent_paths() {
  local project="$1"
  local project_dir="$2"

  if [[ -f "$project_dir/log.md" ]]; then
    print_fail "$project" "misplaced legacy agent log: $project_dir/log.md"
  fi

  if [[ -f "$project_dir/specs/000-roadmap.md" ]]; then
    print_fail "$project" "misplaced legacy roadmap: $project_dir/specs/000-roadmap.md"
  fi
}

check_template_sync_gate() {
  local domain="$1"
  local project="template-sync/$domain"

  CHECKED=$((CHECKED + 1))
  if [[ ! -f "$TEMPLATE_SYNC" ]]; then
    print_fail "$project" "missing script: $TEMPLATE_SYNC"
    return
  fi

  local out
  if out="$(bash "$TEMPLATE_SYNC" --domain "$domain" --dry-run 2>&1)"; then
    print_ok "$project" "synced"
  else
    print_fail "$project" "not synced; run 'bash $TEMPLATE_SYNC --domain $domain --apply' ($out)"
  fi
}

# ---------- project checks ----------
check_project() {
  local area="$1"
  local project_dir="$2"
  local name
  name="$(basename "$project_dir")"
  local project="$area/$name"

  CHECKED=$((CHECKED + 1))

  if ! is_kebab_case "$name"; then
    print_fail "$project" "project name is not kebab-case"
  fi

  require_file "$project" "$project_dir/AGENTS.md"
  check_agents_logging_timestamp_rule "$project" "$project_dir/AGENTS.md"
  require_file "$project" "$project_dir/agent/docs/arch.md"
  require_file "$project" "$project_dir/agent/docs/kb.md"
  require_file "$project" "$project_dir/agent/docs/run.md"
  require_file "$project" "$project_dir/agent/specs/000-roadmap.md"
  require_file "$project" "$project_dir/agent/log.md"
  require_any_file "$project" "run entrypoint" "$project_dir/agent/scripts/run.sh" "$project_dir/scripts/run.sh"
  require_any_file "$project" "build entrypoint" "$project_dir/agent/scripts/build.sh" "$project_dir/scripts/build.sh"
  require_any_file "$project" "monitor entrypoint" "$project_dir/agent/scripts/monitor.sh" "$project_dir/scripts/monitor.sh"
  require_any_file "$project" "source anchor" "$project_dir/agent/src/.gitkeep" "$project_dir/src/.gitkeep"
  [[ -d "$project_dir/agent/docs" ]] || print_fail "$project" "missing directory: $project_dir/agent/docs"

  check_log_file "$project" "$project_dir/agent/log.md"
  check_legacy_agent_paths "$project" "$project_dir"

  if [[ "$area" == "web" ]]; then
    [[ -d "$project_dir/web" ]] || print_fail "$project" "missing directory: $project_dir/web"
  fi

  print_ok "$project" "checked"
}

# ---------- area scan ----------
scan_area() {
  local area="$1"
  local base="$2"

  [[ -d "$base" ]] || return

  local found=0
  for d in "$base"/*; do
    [[ -d "$d" ]] || continue
    local name
    name="$(basename "$d")"
    [[ "$name" == _* ]] && continue
    found=1
    check_project "$area" "$d"
  done

  if [[ "$found" -eq 0 ]]; then
    echo "[INFO] no projects found in $base (excluding _*)"
  fi
}

# ---------- execution ----------
check_template_sync_gate "code"
check_template_sync_gate "web"
scan_area "code" "$CODE_ROOT"
scan_area "web" "$WEB_ROOT"

if [[ "$FAILED" -gt 0 ]]; then
  echo "policy-check: FAIL (checked=$CHECKED, failures=$FAILED)"
  exit 1
fi

echo "policy-check: SUCCESS (checked=$CHECKED, failures=0)"
