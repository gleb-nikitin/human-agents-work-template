#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)"
POLICY_CHECK="$SCRIPT_DIR/policy-check.sh"
TEMPLATE_SYNC="$SCRIPT_DIR/template-sync.sh"

FAILED=0
CHECKED=0

ok() {
  local label="$1"
  local msg="$2"
  echo "[OK]   $label :: $msg"
}

info() {
  local label="$1"
  local msg="$2"
  echo "[INFO] $label :: $msg"
}

fail() {
  local label="$1"
  local msg="$2"
  echo "[FAIL] $label :: $msg"
  FAILED=$((FAILED + 1))
}

require_file() {
  local label="$1"
  local path="$2"
  CHECKED=$((CHECKED + 1))
  if [[ -f "$path" ]]; then
    ok "$label" "present: $path"
  else
    fail "$label" "missing: $path"
  fi
}

require_dir() {
  local label="$1"
  local path="$2"
  CHECKED=$((CHECKED + 1))
  if [[ -d "$path" ]]; then
    ok "$label" "present: $path"
  else
    fail "$label" "missing: $path"
  fi
}

require_absent_file() {
  local label="$1"
  local path="$2"
  CHECKED=$((CHECKED + 1))
  if [[ -f "$path" ]]; then
    fail "$label" "misplaced legacy file must not exist: $path"
  else
    ok "$label" "absent legacy path: $path"
  fi
}

require_absent_dir() {
  local label="$1"
  local path="$2"
  CHECKED=$((CHECKED + 1))
  if [[ -d "$path" ]]; then
    fail "$label" "misplaced legacy directory must not exist: $path"
  else
    ok "$label" "absent legacy path: $path"
  fi
}

check_workspace() {
  local label="workspace"
  require_file "$label" "$ROOT/AGENTS.md"
  require_file "$label" "$ROOT/agent/log.md"
  require_file "$label" "$ROOT/agent/docs/context.md"
  require_file "$label" "$ROOT/agent/docs/arch.md"
  require_file "$label" "$ROOT/agent/docs/kb.md"
  require_file "$label" "$ROOT/agent/docs/run.md"
  require_file "$label" "$ROOT/agent/specs/000-roadmap.md"
}

check_template() {
  local area="$1"
  local dir="$ROOT/$area/_project-template"
  local label="$area/_project-template"
  require_file "$label" "$dir/AGENTS.md"
  require_file "$label" "$dir/CLAUDE.md"
  require_file "$label" "$dir/agent/log.md"
  require_file "$label" "$dir/agent/docs/context.md"
  require_file "$label" "$dir/agent/docs/arch.md"
  require_file "$label" "$dir/agent/docs/kb.md"
  require_file "$label" "$dir/agent/docs/run.md"
  require_file "$label" "$dir/agent/specs/000-roadmap.md"
  require_file "$label" "$dir/agent/scripts/run.sh"
  require_file "$label" "$dir/agent/scripts/build.sh"
  require_file "$label" "$dir/agent/scripts/monitor.sh"
  require_file "$label" "$dir/agent/src/.gitkeep"
  require_absent_file "$label" "$dir/log.md"
  require_absent_file "$label" "$dir/specs/000-roadmap.md"
  require_absent_file "$label" "$dir/docs/arch.md"
  require_absent_file "$label" "$dir/docs/kb.md"
  require_absent_file "$label" "$dir/docs/run.md"
  require_absent_dir "$label" "$dir/scripts"
  require_absent_dir "$label" "$dir/src"
}

check_bootstrap_procedure() {
  local label="bootstrap-procedure"
  local script="$SCRIPT_DIR/new-project.sh"

  require_file "$label" "$script"
  [[ -f "$script" ]] || return

  local out_code
  local out_web

  CHECKED=$((CHECKED + 1))
  if out_code="$(bash "$script" code protocol-check-code --purpose "protocol-check" --stack "template-bootstrap" --boundaries "dry-run validation" --dry-run 2>&1)"; then
    if grep -Fq "ensure roadmap exists" <<<"$out_code"; then
      ok "$label" "code bootstrap dry-run passed"
    else
      fail "$label" "code bootstrap dry-run missing roadmap signal"
    fi
  else
    fail "$label" "code bootstrap dry-run failed"
  fi

  CHECKED=$((CHECKED + 1))
  if out_web="$(bash "$script" web protocol-check-web --purpose "protocol-check" --stack "template-bootstrap" --boundaries "dry-run validation" --deployment "containerized web service" --dry-run 2>&1)"; then
    if grep -Fq "ensure roadmap exists" <<<"$out_web"; then
      ok "$label" "web bootstrap dry-run passed"
    else
      fail "$label" "web bootstrap dry-run missing roadmap signal"
    fi
  else
    fail "$label" "web bootstrap dry-run failed"
  fi
}

check_template_sync_gates() {
  local label="template-sync"
  if [[ ! -f "$TEMPLATE_SYNC" ]]; then
    CHECKED=$((CHECKED + 1))
    fail "$label" "missing script: $TEMPLATE_SYNC"
    return
  fi

  local out

  CHECKED=$((CHECKED + 1))
  if out="$(bash "$TEMPLATE_SYNC" --domain code --dry-run 2>&1)"; then
    ok "$label" "code synced"
  else
    fail "$label" "code not synced; run 'bash $TEMPLATE_SYNC --domain code --apply' ($out)"
  fi

  CHECKED=$((CHECKED + 1))
  if out="$(bash "$TEMPLATE_SYNC" --domain web --dry-run 2>&1)"; then
    ok "$label" "web synced"
  else
    fail "$label" "web not synced; run 'bash $TEMPLATE_SYNC --domain web --apply' ($out)"
  fi
}

check_active_projects() {
  local label="active-projects"
  if [[ ! -f "$POLICY_CHECK" ]]; then
    fail "$label" "missing script: $POLICY_CHECK"
    return
  fi
  CHECKED=$((CHECKED + 1))
  if bash "$POLICY_CHECK"; then
    ok "$label" "policy-check passed"
  else
    fail "$label" "policy-check failed"
  fi
}

check_skills_workspace() {
  local skills_root="$ROOT/rss/skills"
  local label="rss/skills"

  require_dir "$label" "$skills_root"
  [[ -d "$skills_root" ]] || return

  CHECKED=$((CHECKED + 1))
  if [[ -f "$skills_root/AGENTS.md" ]]; then
    ok "$label" "present: $skills_root/AGENTS.md"
  else
    info "$label" "optional baseline file missing: $skills_root/AGENTS.md"
  fi

  CHECKED=$((CHECKED + 1))
  if [[ -f "$skills_root/agent/log.md" ]]; then
    ok "$label" "present: $skills_root/agent/log.md"
  else
    info "$label" "optional baseline file missing: $skills_root/agent/log.md"
  fi

  require_absent_file "$label" "$skills_root/log.md"

  local d
  for d in "$skills_root"/*; do
    [[ -d "$d" ]] || continue
    local name
    name="$(basename "$d")"
    [[ "$name" == .* ]] && continue
    [[ "$name" == "agent" ]] && continue
    [[ "$name" == "__pycache__" ]] && continue
    CHECKED=$((CHECKED + 1))
    if [[ -f "$d/SKILL.md" ]]; then
      ok "$label" "skill folder ok: $d/SKILL.md"
    else
      fail "$label" "top-level folder without SKILL.md: $d"
    fi
  done
}

check_workspace
check_template_sync_gates
check_template "code"
check_template "web"
check_bootstrap_procedure
check_active_projects
check_skills_workspace

if [[ "$FAILED" -gt 0 ]]; then
  echo "onboarding-check: FAIL (checked=$CHECKED, failures=$FAILED)"
  exit 1
fi

echo "onboarding-check: SUCCESS (checked=$CHECKED, failures=0)"
