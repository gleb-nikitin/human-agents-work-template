#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)"
CODE_ROOT="$ROOT/code"
WEB_ROOT="$ROOT/web"

FAILED=0
CHECKED=0

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
    if [[ "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}\ \|\ .+\ \|\ .+$ ]]; then
      has_entry=1
    else
      print_fail "$project" "invalid log format at line $lineno in $log_file"
    fi
  done < "$log_file"

  if [[ "$has_entry" -eq 0 ]]; then
    print_fail "$project" "log has no factual entries: $log_file"
  fi
}

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
  require_file "$project" "$project_dir/docs/arch.md"
  require_file "$project" "$project_dir/docs/kb.md"
  require_file "$project" "$project_dir/docs/run.md"
  require_file "$project" "$project_dir/scripts/run.sh"
  require_file "$project" "$project_dir/scripts/build.sh"
  require_file "$project" "$project_dir/scripts/monitor.sh"
  require_file "$project" "$project_dir/src/.gitkeep"

  check_log_file "$project" "$project_dir/log.md"

  if [[ "$area" == "web" ]]; then
    [[ -d "$project_dir/web" ]] || print_fail "$project" "missing directory: $project_dir/web"
  fi

  print_ok "$project" "checked"
}

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

scan_area "code" "$CODE_ROOT"
scan_area "web" "$WEB_ROOT"

if [[ "$FAILED" -gt 0 ]]; then
  echo "policy-check: FAIL (checked=$CHECKED, failures=$FAILED)"
  exit 1
fi

echo "policy-check: SUCCESS (checked=$CHECKED, failures=0)"
